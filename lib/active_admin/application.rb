require 'active_admin/router'
require 'active_admin/helpers/settings'

module ActiveAdmin
  class Application
    include Settings

    # Adds settings to both the Application and the Namespace instance
    # so that they can be configured independantly.
    def self.inheritable_setting(name, default)
      Namespace.setting name, nil
      setting name, default
    end

    # The default namespace to put controllers and routes inside. Set this
    # in config/initializers/active_admin.rb using:
    #
    #   config.default_namespace = :super_admin
    #
    setting :default_namespace, :admin

    # A hash of all the registered namespaces
    setting :namespaces, {}

    # Load paths for admin configurations. Add folders to this load path
    # to load up other resources for administration. External gems can
    # include their paths in this load path to provide active_admin UIs
    setting :load_paths, [File.expand_path('app/admin', Rails.root)]

    # The default number of resources to display on index pages
    inheritable_setting :default_per_page, 30

    # The title which gets displayed in the main layout
    inheritable_setting :site_title, ""

    # Set the site title link href (defaults to AA dashboard)
    inheritable_setting :site_title_link, ""

    # Set the site title image displayed in the main layout (has precendence over :site_title)
    inheritable_setting :site_title_image, ""

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

    # Active Admin makes educated guesses when displaying objects, this is
    # the list of methods it tries calling in order
    setting :display_name_methods, [ :display_name,
                                      :full_name,
                                      :name,
                                      :username,
                                      :login,
                                      :title,
                                      :email,
                                      :to_s ]

    # == Deprecated Settings

    # @deprecated The default sort order for index pages
    deprecated_setting :default_sort_order, 'id_desc'

    # DEPRECATED: This option is deprecated and will be removed. Use
    # the #allow_comments_in option instead
    attr_accessor :admin_notes

    include AssetRegistration

    # Event that gets triggered on load of Active Admin
    LoadEvent = 'active_admin.application.load'.freeze

    def setup!
      register_default_assets
    end

    def prepare!
      remove_active_admin_load_paths_from_rails_autoload_and_eager_load
      attach_reloader
      generate_stylesheets
    end

    # Registers a brand new configuration for the given resource.
    def register(resource, options = {}, &block)
      namespace_name = extract_namespace_name(options)
      namespace = find_or_create_namespace(namespace_name)
      namespace.register(resource, options, &block)
    end

    # Creates a namespace for the given name
    #
    # Yields the namespace if a block is given
    #
    # @returns [Namespace] the new or existing namespace
    def find_or_create_namespace(name)
      name ||= :root
      return namespaces[name] if namespaces[name]
      namespace = Namespace.new(self, name)
      namespaces[name] = namespace
      ActiveAdmin::Event.dispatch ActiveAdmin::Namespace::RegisterEvent, namespace
      yield(namespace) if block_given?
      namespace
    end

    alias_method :namespace, :find_or_create_namespace

    # Register a page
    #
    # @param name [String] The page name
    # @options [Hash] Accepts option :namespace.
    # @&block The registration block.
    #
    def register_page(name, options = {}, &block)
      namespace_name = extract_namespace_name(options)
      namespace = find_or_create_namespace(namespace_name)
      namespace.register_page(name, options, &block)
    end

    # Stores if everything has been loaded or we need to reload
    @@loaded = false

    # Returns true if all the configuration files have been loaded.
    def loaded?
      @@loaded
    end

    # Removes all the controllers that were defined by registering
    # resources for administration.
    #
    # We remove them, then load them on each request in development
    # to allow for changes without having to restart the server.
    def unload!
      namespaces.values.each{|namespace| namespace.unload! }
      @@loaded = false
    end

    # Loads all of the ruby files that are within the load path of
    # ActiveAdmin.load_paths. This should load all of the administration
    # UIs so that they are available for the router to proceed.
    #
    # The files are only loaded if we haven't already loaded all the files
    # and they aren't marked for re-loading. To mark the files for re-loading
    # you must first call ActiveAdmin.unload!
    def load!
      # No work to do if we've already loaded
      return false if loaded?

      # Load files
      files_in_load_path.each{|file| load file }

      # If no configurations, let's make sure you can still login
      load_default_namespace if namespaces.values.empty?

      # Load Menus
      namespaces.values.each{|namespace| namespace.load_menu! }

      # Dispatch an ActiveAdmin::Application::LoadEvent with the Application
      ActiveAdmin::Event.dispatch LoadEvent, self

      @@loaded = true
    end

    # Returns ALL the files to load from all the load paths
    def files_in_load_path
      load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
    end

    def router
      @router ||= Router.new(self)
    end

    def routes(rails_router)
      # Ensure that all the configurations (which define the routes)
      # are all loaded
      load!

      router.apply(rails_router)
    end

    def load_default_namespace
      find_or_create_namespace(default_namespace)
    end

    #
    # Add before, around and after filters to each registered resource.
    #
    # eg:
    #
    #   ActiveAdmin.before_filter :authenticate_admin!
    #
    def before_filter(*args, &block)
      ResourceController.before_filter(*args, &block)
    end

    def skip_before_filter(*args, &block)
      ResourceController.skip_before_filter(*args, &block)
    end

    def after_filter(*args, &block)
      ResourceController.after_filter(*args, &block)
    end

    def around_filter(*args, &block)
      ResourceController.around_filter(*args, &block)
    end

    # Helper method to add a dashboard section
    def dashboard_section(name, options = {}, &block)
      ActiveAdmin::Dashboards.add_section(name, options, &block)
    end

    private

    def register_default_assets
      register_stylesheet 'active_admin.css', :media => 'screen'

      if !ActiveAdmin.use_asset_pipeline?
        register_javascript 'jquery.min.js'
        register_javascript 'jquery-ui.min.js'
        register_javascript 'jquery_ujs.js'
      end

      register_javascript 'active_admin.js'
    end

    def extract_namespace_name(options)
      options.has_key?(:namespace) ? options[:namespace] : default_namespace
    end

    # Since we're dealing with all our own file loading, we need
    # to remove our paths from the ActiveSupport autoload paths.
    # If not, file naming becomes very important and can cause clashes.
    def remove_active_admin_load_paths_from_rails_autoload_and_eager_load
      ActiveSupport::Dependencies.autoload_paths.reject!{|path| load_paths.include?(path) }
      # Don't eagerload our configs, we'll deal with them ourselves
      Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.reject do |path|
        load_paths.include?(path)
      end
    end

    def attach_reloader
      ActiveAdmin::Reloader.build(Rails.application, self, Rails.version).attach!
    end

    def generate_stylesheets
      # Create our own asset pipeline in Rails 3.0
      if ActiveAdmin.use_asset_pipeline?
        # Add our mixins to the load path for SASS
        ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] <<  File.expand_path("../../../app/assets/stylesheets", __FILE__)
      else
        require 'active_admin/sass/css_loader'
        ::Sass::Plugin.add_template_location(File.expand_path("../../../app/assets/stylesheets", __FILE__))
        ::Sass::Plugin.add_template_location(File.expand_path("../sass", __FILE__))
      end
    end
  end
end
