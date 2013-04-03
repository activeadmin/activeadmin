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

    def self.deprecated_inheritable_setting(name, default)
      Namespace.deprecated_setting name, nil
      deprecated_setting name, default
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

    # Whether the batch actions are enabled or not
    inheritable_setting :batch_actions, false

    # Whether filters are enabled
    inheritable_setting :filters, true

    # The namespace root.
    inheritable_setting :root_to, 'dashboard#index'

    # Default CSV options
    inheritable_setting :csv_options, {}

    # Default Download Links options
    inheritable_setting :download_links, true

    # The authorization adapter to use
    inheritable_setting :authorization_adapter, ActiveAdmin::AuthorizationAdapter

    # A proc to be used when a user is not authorized to view the current resource
    inheritable_setting :on_unauthorized_access, :rescue_active_admin_access_denied

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

    # @deprecated Default CSV separator will be removed in 0.6.0. Use `csv_options = { :col_sep => ',' }` instead.
    deprecated_inheritable_setting :csv_column_separator, ','

    # @deprecated The default sort order for index pages
    deprecated_setting :default_sort_order, 'id_desc'

    # DEPRECATED: This option is deprecated and will be removed. Use
    # the #allow_comments_in option instead
    attr_accessor :admin_notes

    include AssetRegistration

    # Event that gets triggered on load of Active Admin
    BeforeLoadEvent = 'active_admin.application.before_load'.freeze
    AfterLoadEvent = 'active_admin.application.after_load'.freeze

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
      ns_name = namespace_name(options)
      namespace(ns_name).register resource, options, &block
    end

    # Creates a namespace for the given name
    #
    # Yields the namespace if a block is given
    #
    # @returns [Namespace] the new or existing namespace
    def namespace(name)
      name ||= :root

      if namespaces[name]
        namespace = namespaces[name]
      else
        namespace = namespaces[name] = Namespace.new(self, name)
        ActiveAdmin::Event.dispatch ActiveAdmin::Namespace::RegisterEvent, namespace
      end

      yield(namespace) if block_given?

      namespace
    end

    # Register a page
    #
    # @param name [String] The page name
    # @options [Hash] Accepts option :namespace.
    # @&block The registration block.
    #
    def register_page(name, options = {}, &block)
      ns_name = namespace_name(options)
      namespace(ns_name).register_page name, options, &block
    end

    # Whether all configuration files have been loaded
    def loaded?
      @@loaded ||= false
    end

    # Removes all defined controllers from memory. Useful in
    # development, where they are reloaded on each request.
    def unload!
      namespaces.values.each{ |namespace| namespace.unload! }
      @@loaded = false
    end

    # Loads all ruby files that are within the load_paths setting.
    # To reload everything simply call `ActiveAdmin.unload!`
    def load!
      unless loaded?
        ActiveAdmin::Event.dispatch BeforeLoadEvent, self # before_load hook
        files.each{ |file| load file }                    # load files
        namespace(nil)                                    # init AA resources
        ActiveAdmin::Event.dispatch AfterLoadEvent, self  # after_load hook
        @@loaded = true
      end
    end

    # Returns ALL the files to be loaded
    def files
      load_paths.flatten.compact.uniq.map{ |path| Dir["#{path}/**/*.rb"] }.flatten
    end

    def router
      @router ||= Router.new(self)
    end

    # One-liner called by user's config/routes.rb file
    def routes(rails_router)
      load!
      router.apply(rails_router)
    end

    # Add before, around and after filters to each registered resource and pages.
    # For example:
    #   ActiveAdmin.before_filter :authenticate_admin!
    #
    %w(before_filter skip_before_filter after_filter around_filter).each do |name|
      define_method name do |*args, &block|
        BaseController.send name, *args, &block
      end
    end

    # Helper method to add a dashboard section
    def dashboard_section(name, options = {}, &block)
      ActiveAdmin::Dashboards.add_section(name, options, &block)
    end

    private

    # Return either the passed in namespace or the default
    def namespace_name(options)
      options.fetch(:namespace){ default_namespace }
    end

    def register_default_assets
      register_stylesheet 'active_admin.css', :media => 'screen'
      register_stylesheet 'active_admin/print.css', :media => 'print'

      unless ActiveAdmin.use_asset_pipeline?
        register_javascript 'jquery.min.js'
        register_javascript 'jquery-ui.min.js'
        register_javascript 'jquery_ujs.js'
      end

      register_javascript 'active_admin.js'
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
