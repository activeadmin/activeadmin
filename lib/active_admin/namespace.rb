# frozen_string_literal: true
require_relative "resource_collection"

module ActiveAdmin

  # Namespaces are the basic organizing principle for resources within Active Admin
  #
  # Each resource is registered into a namespace which defines:
  #   * the namespaceing for routing
  #   * the module to namespace controllers
  #   * the menu which gets displayed (other resources in the same namespace)
  #
  # For example:
  #
  #   ActiveAdmin.register Post, namespace: :admin
  #
  # Will register the Post model into the "admin" namespace. This will namespace the
  # urls for the resource to "/admin/posts" and will set the controller to
  # Admin::PostsController
  #
  # You can also register to the "root" namespace, which is to say no namespace at all.
  #
  #   ActiveAdmin.register Post, namespace: false
  #
  # This will register the resource to an instantiated namespace called :root. The
  # resource will be accessible from "/posts" and the controller will be PostsController.
  #
  class Namespace
    class << self
      def setting(name, default)
        ActiveAdmin.deprecator.warn "This method does not do anything and will be removed."
      end
    end

    RegisterEvent = "active_admin.namespace.register".freeze

    attr_reader :application, :resources, :menus

    def initialize(application, name)
      @application = application
      @name = name.to_s.underscore
      @resources = ResourceCollection.new
      register_module unless root?
      build_menu_collection
    end

    def name
      @name.to_sym
    end

    def settings
      @settings ||= SettingsNode.build(application.namespace_settings)
    end

    def respond_to_missing?(method, include_private = false)
      settings.respond_to?(method) || super
    end

    def method_missing(method, *args)
      settings.respond_to?(method) ? settings.send(method, *args) : super
    end

    # Register a resource into this namespace. The preferred method to access this is to
    # use the global registration ActiveAdmin.register which delegates to the proper
    # namespace instance.
    def register(resource_class, options = {}, &block)
      config = find_or_build_resource(resource_class, options)

      # Register the resource
      register_resource_controller(config)
      parse_registration_block(config, &block) if block
      reset_menu!

      # Dispatch a registration event
      ActiveSupport::Notifications.instrument ActiveAdmin::Resource::RegisterEvent, { active_admin_resource: config }

      # Return the config
      config
    end

    def register_page(name, options = {}, &block)
      config = build_page(name, options)

      # Register the resource
      register_page_controller(config)
      parse_page_registration_block(config, &block) if block
      reset_menu!

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
      root? ? nil : @name.camelize
    end

    def route_prefix
      root? ? nil : @name
    end

    # Unload all the registered resources for this namespace
    def unload!
      unload_resources!
      reset_menu!
    end

    # Returns the first registered ActiveAdmin::Resource instance for a given class
    def resource_for(klass)
      resources[klass]
    end

    def fetch_menu(name)
      @menus.fetch(name)
    end

    def reset_menu!
      @menus.clear!
    end

    # Add a callback to be ran when we build the menu
    #
    # @param [Symbol] name The name of the menu. Default: :default
    # @yield [ActiveAdmin::Menu] The block to be ran when the menu is built
    #
    # @return [void]
    def build_menu(name = DEFAULT_MENU)
      @menus.before_build do |menus|
        menus.menu name do |menu|
          yield menu
        end
      end
    end

    protected

    def build_menu_collection
      @menus = MenuCollection.new

      @menus.on_build do
        resources.each do |resource|
          resource.add_to_menu(@menus)
        end
      end
    end

    # Either returns an existing Resource instance or builds a new one.
    def find_or_build_resource(resource_class, options)
      resources.add Resource.new(self, resource_class, options)
    end

    def build_page(name, options)
      resources.add Page.new(self, name, options)
    end

    # TODO: replace `eval` with `Class.new`
    def register_page_controller(config)
      eval "class ::#{config.controller_name} < ActiveAdmin::PageController; end"
      config.controller.active_admin_config = config
    end

    def unload_resources!
      resources.each do |resource|
        parent = (module_name || "Object").constantize
        name = resource.controller_name.split("::").last
        parent.send(:remove_const, name) if parent.const_defined?(name, false)

        # Remove circular references
        resource.controller.active_admin_config = nil
        if resource.is_a?(Resource) && resource.dsl
          resource.dsl.run_registration_block { @config = nil }
        end
      end
      @resources = ResourceCollection.new
    end

    # Creates a ruby module to namespace all the classes in if required
    def register_module
      unless Object.const_defined? module_name
        Object.const_set module_name, Module.new
      end
    end

    # TODO: replace `eval` with `Class.new`
    def register_resource_controller(config)
      eval "class ::#{config.controller_name} < ActiveAdmin::ResourceController; end"
      config.controller.active_admin_config = config
    end

    def parse_registration_block(config, &block)
      config.dsl = ResourceDSL.new(config)
      config.dsl.run_registration_block(&block)
    end

    def parse_page_registration_block(config, &block)
      PageDSL.new(config).run_registration_block(&block)
    end

    class Store
      include Enumerable
      delegate :[], :[]=, :empty?, to: :@namespaces

      def initialize
        @namespaces = {}
      end

      def each(&block)
        @namespaces.values.each(&block)
      end

      def names
        @namespaces.keys
      end
    end
  end
end
