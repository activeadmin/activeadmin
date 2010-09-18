module ActiveAdmin
  class Namespace

    attr_reader :resources, :name, :menu

    def initialize(name)
      @name = name.to_s.underscore.to_sym
      @resources = {}
      @menu = Menu.new
    end

    def register(resource, options = {}, &block)
      # Init and store the resource
      config = Resource.new(self, resource, options)
      @resources[config.camelized_resource_name] = config

      # Register the resource
      register_module unless root?
      register_resource_controller(config, &block)
      register_dashboard_controller(config)
      register_with_menu(config)
      register_with_admin_comments(config)
      
      # Return the config
      config
    end

    def root?
      name == :root
    end

    # Returns the name of the module if required. Will be nil if none
    # is required.
    #
    # eg: 
    #   Namespace.new(:admin).module_name # => 'Admin'
    #   Namespace.new(:root).module_name # => nil
    #
    def module_name
      return nil if root?
      @module_name ||= name.to_s.camelize
    end

    # Unload all the registered resources for this namespace
    def unload!
      unload_resources!
      unload_dashboard!
      unload_menu!
    end

    protected

    def unload_resources!
      resources.each do |name, config|
        parent = (module_name || 'Object').constantize
        const_name = config.controller_name.split('::').last
        # Remove the const if its been defined
        parent.send(:remove_const, const_name) if parent.const_defined?(const_name)
      end
    end

    def unload_dashboard!
      # TODO: Only clear out my sections
      Dashboards.clear_all_sections!
    end

    def unload_menu!
      @menu = Menu.new
    end

    # Creates a ruby module to namespace all the classes in if required
    def register_module
      eval "module ::#{module_name}; end"
    end

    def register_resource_controller(config, &block)
      eval "class ::#{config.controller_name} < ActiveAdmin::ResourceController; end"
      config.controller.active_admin_config = config
      config.controller.class_eval(&block) if block_given?
    end

    # Creates a dashboard controller for this config
    def register_dashboard_controller(config)
      eval "class ::#{config.dashboard_controller_name} < ActiveAdmin::Dashboards::DashboardController; end"
    end

    # Does all the work of registernig a config with the menu system
    def register_with_menu(config)
      menu.add("Dashboard", "#{name}_dashboard_path".to_sym, 1) unless menu["Dashboard"]

      # The menu we're going to add this resource to
      add_to = menu

      # Adding as a child
      if config.parent_menu_item_name
        # Create the parent if it doesn't exist
        menu.add(config.parent_menu_item_name, '#') unless menu[config.parent_menu_item_name]
        add_to = menu[config.parent_menu_item_name]
      end

      # Check if this menu item has already been created
      if add_to[config.menu_item_name]
        # Update the url if it's already been created
        add_to[config.menu_item_name].url = config.route_collection_path
      else
        add_to.add(config.menu_item_name, config.route_collection_path)
      end
    end
    
    def register_with_admin_comments(config)
      config.resource.has_many :admin_comments, :as => :entity, :class_name => "ActiveAdmin::AdminComment"
      
    end


  end
end
