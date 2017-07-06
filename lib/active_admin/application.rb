require 'active_admin/router'
require 'active_admin/reloader'
require 'active_admin/helpers/settings'

module ActiveAdmin
  class Application
    include Settings
    include Settings::Inheritance

    settings_inherited_by Namespace

    # The default namespace to put controllers and routes inside. Set this
    # in config/initializers/active_admin.rb using:
    #
    #   config.default_namespace = :super_admin
    #
    setting :default_namespace, :admin

    attr_reader :namespaces
    def initialize
      @namespaces = Namespace::Store.new
    end

    # Load paths for admin configurations. Add folders to this load path
    # to load up other resources for administration. External gems can
    # include their paths in this load path to provide active_admin UIs
    setting :load_paths, [File.expand_path('app/admin', Rails.root)]

    # The default number of resources to display on index pages
    inheritable_setting :default_per_page, 30

    # The max number of resources to display on index pages and batch exports
    inheritable_setting :max_per_page, 10_000

    # The title which gets displayed in the main layout
    inheritable_setting :site_title, ""

    # Set the site title link href (defaults to AA dashboard)
    inheritable_setting :site_title_link, ""

    # Set the site title image displayed in the main layout (has precendence over :site_title)
    inheritable_setting :site_title_image, ""

    # Set the site footer text (defaults to Powered by ActiveAdmin text with version)
    inheritable_setting :footer, ""

    # Set a favicon
    inheritable_setting :favicon, false

    # Additional meta tags to place in head of logged in pages.
    inheritable_setting :meta_tags, {}

    # Additional meta tags to place in head of logged out pages.
    inheritable_setting :meta_tags_for_logged_out_pages, { robots: "noindex, nofollow" }

    # The view factory to use to generate all the view classes. Take
    # a look at ActiveAdmin::ViewFactory
    inheritable_setting :view_factory, ActiveAdmin::ViewFactory.new

    # The method to call in controllers to get the current user
    inheritable_setting :current_user_method, false

    # The method to call in the controllers to ensure that there
    # is a currently authenticated admin user
    inheritable_setting :authentication_method, false

    # The path to log user's out with. If set to a symbol, we assume
    # that it's a method to call which returns the path
    inheritable_setting :logout_link_path, :destroy_admin_user_session_path

    # The method to use when generating the link for user logout
    inheritable_setting :logout_link_method, :get

    # Whether the batch actions are enabled or not
    inheritable_setting :batch_actions, false

    # Whether filters are enabled
    inheritable_setting :filters, true

    # The namespace root.
    inheritable_setting :root_to, 'dashboard#index'

    # Options that a passed to root_to.
    inheritable_setting :root_to_options, {}

    # Options passed to the routes, i.e. { path: '/custom' }
    inheritable_setting :route_options, {}

    # Display breadcrumbs
    inheritable_setting :breadcrumb, true

    # Display create another checkbox on a new page
    # @return [Boolean] (true)
    inheritable_setting :create_another, false

    # Default CSV options
    inheritable_setting :csv_options, { col_sep: ',', byte_order_mark: "\xEF\xBB\xBF" }

    # Default Download Links options
    inheritable_setting :download_links, true

    # The authorization adapter to use
    inheritable_setting :authorization_adapter, ActiveAdmin::AuthorizationAdapter

    # A proc to be used when a user is not authorized to view the current resource
    inheritable_setting :on_unauthorized_access, :rescue_active_admin_access_denied

    # A regex to detect unsupported browser, set to false to disable
    inheritable_setting :unsupported_browser_matcher, /MSIE [1-8]\.0/

    # Whether to display 'Current Filters' on search screen
    inheritable_setting :current_filters, true

    # class to handle ordering
    inheritable_setting :order_clause, ActiveAdmin::OrderClause

    # default show_count for scopes
    inheritable_setting :scopes_show_count, true

    # Request parameters that are permitted by default
    inheritable_setting :permitted_params, [
      :utf8, :_method, :authenticity_token, :commit, :id
    ]

    # Set flash message keys that shouldn't show in ActiveAdmin
    inheritable_setting :flash_keys_to_except, ['timedout']

    # Set default localize format for Date/Time values
    setting :localize_format, :long

    # Include association filters by default
    inheritable_setting :include_default_association_filters, true

    # Active Admin makes educated guesses when displaying objects, this is
    # the list of methods it tries calling in order
    # Note that Formtastic also has 'collection_label_methods' similar to this
    # used by auto generated dropdowns in filter or belongs_to field of Active Admin
    setting :display_name_methods, [ :display_name,
                                      :full_name,
                                      :name,
                                      :username,
                                      :login,
                                      :title,
                                      :email,
                                      :to_s ]

    # To make debugging easier, by default don't stream in development
    setting :disable_streaming_in, ['development']

    # == Deprecated Settings

    def allow_comments=(*)
      raise "`config.allow_comments` is no longer provided in ActiveAdmin 1.x. Use `config.comments` instead."
    end

    include AssetRegistration

    # Event that gets triggered on load of Active Admin
    BeforeLoadEvent = 'active_admin.application.before_load'.freeze
    AfterLoadEvent  = 'active_admin.application.after_load'.freeze

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
      ns = options.fetch(:namespace){ default_namespace }
      namespace(ns).register resource, options, &block
    end

    # Creates a namespace for the given name
    #
    # Yields the namespace if a block is given
    #
    # @return [Namespace] the new or existing namespace
    def namespace(name)
      name ||= :root

      namespace = namespaces[name] ||= begin
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
      ns = options.fetch(:namespace){ default_namespace }
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
        files.each{ |file| load file }                             # load files
        namespace(default_namespace)                               # init AA resources
        ActiveSupport::Notifications.publish AfterLoadEvent, self  # after_load hook
        @@loaded = true
      end
    end

    def load(file)
      DatabaseHitDuringLoad.capture{ super }
    end

    # Returns ALL the files to be loaded
    def files
      load_paths.flatten.compact.uniq.flat_map{ |path| Dir["#{path}/**/*.rb"] }
    end

    def router
      @router ||= Router.new(self)
    end

    # One-liner called by user's config/routes.rb file
    def routes(rails_router)
      load!
      router.apply(rails_router)
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
      stylesheets['active_admin.css'] = { media: 'screen' }
      stylesheets['active_admin/print.css'] = { media: 'print' }
      javascripts.add 'active_admin.js'
    end

    # Since app/admin is alphabetically before app/models, we have to remove it
    # from the host app's +autoload_paths+ to prevent missing constant errors.
    #
    # As well, we have to remove it from +eager_load_paths+ to prevent the
    # files from being loaded twice in production.
    def remove_active_admin_load_paths_from_rails_autoload_and_eager_load
      ActiveSupport::Dependencies.autoload_paths -= load_paths
      Rails.application.config.eager_load_paths  -= load_paths
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
          Reloader.to_prepare(prepend: true, &unload_active_admin)
        else
          # If the user has configured the app to always reload app files after
          # each request, so we should unload the generated classes too.
          Reloader.to_complete(&unload_active_admin)
        end

        admin_dirs = {}

        load_paths.each do |path|
          admin_dirs[path] = [:rb]
        end

        routes_reloader = app.config.file_watcher.new([], admin_dirs) do
          app.reload_routes!
        end

        app.reloaders << routes_reloader

        Reloader.to_prepare do
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
