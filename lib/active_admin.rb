require 'meta_search'

module ActiveAdmin
  
  autoload :Renderer,         'active_admin/renderer'
  autoload :TableBuilder,     'active_admin/table_builder'
  autoload :FormBuilder,      'active_admin/form_builder'
  autoload :TabsRenderer,     'active_admin/tabs_renderer'
  autoload :AdminController,  'active_admin/admin_controller'
  autoload :ViewHelpers,      'active_admin/view_helpers'
  autoload :Breadcrumbs,      'active_admin/breadcrumbs'
  autoload :Filters,          'active_admin/filters'
  autoload :Pages,            'active_admin/pages'
  autoload :Sidebar,          'active_admin/sidebar'
  autoload :ActionItems,      'active_admin/action_items'
  autoload :AssetRegistration,'active_admin/asset_registration'
  autoload :Menu,             'active_admin/menu'
  autoload :MenuItem,         'active_admin/menu_item'
  autoload :ResourceConfig,   'active_admin/resource_config'

  extend AssetRegistration

  # The default namespace to put controllers and routes inside. Set this
  # in config/initializers/active_admin.rb using:
  # 
  #   ActiveAdmin.default_namespace = :super_admin
  #
  mattr_accessor :default_namespace
  @@default_namespace = :admin

  # The default number of resources to display on index pages
  mattr_accessor :default_per_page
  @@default_per_page = 30

  # The default sort order for index pages
  mattr_accessor :default_sort_order
  @@default_sort_order = 'id_desc'

  # A hash of configurations for each of the registered resources
  mattr_accessor :resources
  @@resources = {}

  # The title which get's displayed in the main layout
  mattr_accessor :site_title
  @@site_title = Rails.application.class.name.split("::").first.titlecase

  # Load paths for admin configurations. Add folders to this load path
  # to load up other resources for administration. External gems can
  # include thier paths in this load path to provide active_admin UIs
  mattr_accessor :load_paths
  @@load_paths = [File.expand_path('app/active_admin', Rails.root)]

  # Stores if everything has been loaded or we need to reload
  @@loaded = false

  # A hash containing a menu for each of our namespaces
  mattr_accessor :menus
  @@menus = {}

  class << self

    def setup
      yield self
    end

    def init!
      # Register the default assets
      register_stylesheet 'active_admin.css'
      register_javascript 'active_admin_vendor.js'
      register_javascript 'active_admin.js'

      # Dispatch request which gets triggered once in production
      # and on every require in development mode
      ActionDispatch::Callbacks.to_prepare :active_admin do
        ActiveAdmin.unload!
        # Because every time we load, the routes may have changed
        # we must ensure to load the routes each request (in dev)
        Rails::Application.routes_reloader.reload!
      end
    end

    # Registers a brand new configuration for the given resource.
    #
    # TODO: Setup docs for registration options
    def register(resource, options = {}, &block)
      config = ResourceConfig.new(resource, options)

      # Store the namespaced resource in @@resources
      resources[[config.namespace_module_name, resource.name].compact.join('::')] = config
      
      # Generate the module, controller and eval contents of block inside controller
      eval "module ::#{config.namespace_module_name}; end" if config.namespace
      eval "class ::#{config.controller_name} < ActiveAdmin::AdminController; end"
      config.controller.active_admin_config = config
      config.controller.class_eval(&block) if block_given?
      
      # Find the menu this resource should be added to
      menu = menus[config.menu_name] ||= Menu.new

      # Add a new menu item if it doesn't exist yet
      unless menu[config.menu_item_name]
        menu.add(config.menu_item_name, config.route_collection_path)
      end

      # Return the config
      config
    end

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
      resources.each do |name, config|
        parent = (config.namespace_module_name || 'Object').constantize
        parent.send :remove_const, config.controller_name.split('::').last
      end
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
      unless loaded?
        load_paths.flatten.compact.uniq.each do |path|
          Dir["#{path}/*.rb"].each{|f| load f }
        end
        @@loaded = true
        return true
      end
      false
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    def routes(router)
      # Ensure that all the configurations (which define the routes)
      # are all loaded
      load!

      # Now define the routes for each resource
      router.instance_exec(resources) do |admin_resources|
        admin_resources.each do |name, config|
          if config.namespace
            namespace config.namespace do
              resources config.resource.name.pluralize.underscore
            end
          else
            resources config.resource.name.pluralize.underscore
          end
        end
      end
    end

  end
end

ActiveAdmin.init!
