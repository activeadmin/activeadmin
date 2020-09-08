require "active_admin/router"
require "active_admin/application_settings"
require "active_admin/namespace_settings"

module ActiveAdmin
  class Application

    class << self
      def setting(name, default)
        ApplicationSettings.register name, default
      end

      def inheritable_setting(name, default)
        NamespaceSettings.register name, default
      end
    end

    def settings
      @settings ||= SettingsNode.build(ApplicationSettings)
    end

    def namespace_settings
      @namespace_settings ||= SettingsNode.build(NamespaceSettings)
    end

    def respond_to_missing?(method, include_private = false)
      [settings, namespace_settings].any? { |sets| sets.respond_to?(method) } || super
    end

    def method_missing(method, *args)
      if settings.respond_to?(method)
        settings.send(method, *args)
      elsif namespace_settings.respond_to?(method)
        namespace_settings.send(method, *args)
      else
        super
      end
    end

    attr_reader :namespaces
    def initialize
      @namespaces = Namespace::Store.new
    end

    include AssetRegistration

    # Event that gets triggered on load of Active Admin
    BeforeLoadEvent = "active_admin.application.before_load".freeze
    AfterLoadEvent = "active_admin.application.after_load".freeze

    # Runs before the app's AA initializer
    def setup!
      register_default_assets
    end

    # Runs after the app's AA initializer
    def prepare!
      remove_active_admin_load_paths_from_rails_autoload_and_eager_load
      attach_reloader
    end

    # Registers a brand new configuration for the given resource.
    def register(resource, options = {}, &block)
      ns = options.fetch(:namespace) { default_namespace }
      namespace(ns).register resource, options, &block
    end

    # Creates a namespace for the given name
    #
    # Yields the namespace if a block is given
    #
    # @return [Namespace] the new or existing namespace
    def namespace(name)
      name ||= :root

      namespace = namespaces[name.to_sym] ||= begin
        namespace = Namespace.new(self, name)
        ActiveSupport::Notifications.publish ActiveAdmin::Namespace::RegisterEvent, namespace
        namespace
      end

      yield(namespace) if block_given?

      namespace
    end

    # Register a page
    #
    # @param name [String] The page name
    # @option [Hash] Accepts option :namespace.
    # @&block The registration block.
    #
    def register_page(name, options = {}, &block)
      ns = options.fetch(:namespace) { default_namespace }
      namespace(ns).register_page name, options, &block
    end

    # Whether all configuration files have been loaded
    def loaded?
      @@loaded ||= false
    end

    # Removes all defined controllers from memory. Useful in
    # development, where they are reloaded on each request.
    def unload!
      namespaces.each &:unload!
      @@loaded = false
    end

    # Loads all ruby files that are within the load_paths setting.
    # To reload everything simply call `ActiveAdmin.unload!`
    def load!
      unless loaded?
        ActiveSupport::Notifications.publish BeforeLoadEvent, self # before_load hook
        files.each { |file| load file } # load files
        namespace(default_namespace) # init AA resources
        ActiveSupport::Notifications.publish AfterLoadEvent, self # after_load hook
        @@loaded = true
      end
    end

    def load(file)
      DatabaseHitDuringLoad.capture { super }
    end

    # Returns ALL the files to be loaded
    def files
      load_paths.flatten.compact.uniq.flat_map { |path| Dir["#{path}/**/*.rb"] }.sort
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    # @param rails_router [ActionDispatch::Routing::Mapper]
    def routes(rails_router)
      load!
      Router.new(router: rails_router, namespaces: namespaces).apply
    end

    # Adds before, around and after filters to all controllers.
    # Example usage:
    #   ActiveAdmin.before_filter :authenticate_admin!
    #
    AbstractController::Callbacks::ClassMethods.public_instance_methods.
      select { |m| m.match(/(filter|action)/) }.each do |name|
      define_method name do |*args, &block|
        controllers_for_filters.each do |controller|
          controller.public_send name, *args, &block
        end
      end
    end

    def controllers_for_filters
      controllers = [BaseController]
      controllers.push *Devise.controllers_for_filters if Dependency.devise?
      controllers
    end

    private

    def register_default_assets
      register_stylesheet "active_admin.css", media: "screen"
      register_stylesheet "active_admin/print.css", media: "print"
      register_javascript "active_admin.js"
    end

    # Since app/admin is alphabetically before app/models, we have to remove it
    # from the host app's +autoload_paths+ to prevent missing constant errors.
    #
    # As well, we have to remove it from +eager_load_paths+ to prevent the
    # files from being loaded twice in production.
    def remove_active_admin_load_paths_from_rails_autoload_and_eager_load
      ActiveSupport::Dependencies.autoload_paths -= load_paths
      Rails.application.config.eager_load_paths -= load_paths
    end

    # Hook into the Rails code reloading mechanism so that things are reloaded
    # properly in development mode.
    #
    # If any of the app files (e.g. models) has changed, we need to reload all
    # the admin files. If the admin files themselves has changed, we need to
    # regenerate the routes as well.
    def attach_reloader
      Rails.application.config.after_initialize do |app|
        unload_active_admin = -> { ActiveAdmin.application.unload! }

        if app.config.reload_classes_only_on_change
          # Rails is about to unload all the app files (e.g. models), so we
          # should first unload the classes generated by Active Admin, otherwise
          # they will contain references to the stale (unloaded) classes.
          ActiveSupport::Reloader.to_prepare(prepend: true, &unload_active_admin)
        else
          # If the user has configured the app to always reload app files after
          # each request, so we should unload the generated classes too.
          ActiveSupport::Reloader.to_complete(&unload_active_admin)
        end

        admin_dirs = {}

        load_paths.each do |path|
          admin_dirs[path] = [:rb]
        end

        routes_reloader = app.config.file_watcher.new([], admin_dirs) do
          app.reload_routes!
        end

        app.reloaders << routes_reloader

        ActiveSupport::Reloader.to_prepare do
          # Rails might have reloaded the routes for other reasons (e.g.
          # routes.rb has changed), in which case Active Admin would have been
          # loaded via the `ActiveAdmin.routes` call in `routes.rb`.
          #
          # Otherwise, we should check if any of the admin files are changed
          # and force the routes to reload if necessary. This would again causes
          # Active Admin to load via `ActiveAdmin.routes`.
          #
          # Finally, if Active Admin is still not loaded at this point, then we
          # would need to load it manually.
          unless ActiveAdmin.application.loaded?
            routes_reloader.execute_if_updated
            ActiveAdmin.application.load!
          end
        end
      end
    end
  end
end
