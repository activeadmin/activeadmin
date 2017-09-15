module ActiveAdmin
  class Router
    def initialize(application)
      @application = application
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    # @param router [ActionDispatch::Routing::Mapper]
    def apply(router)
      define_root_routes(router)
      define_resources_routes(router)
    end

    private

    def define_root_routes(router)
      @application.namespaces.each do |namespace|
        if namespace.root?
          router.root namespace.root_to_options.merge(to: namespace.root_to)
        else
          router.namespace namespace.name, namespace.route_options.dup do
            router.root namespace.root_to_options.merge(to: namespace.root_to, as: :root)
          end
        end
      end
    end

    # Defines the routes for each resource
    def define_resources_routes(router)
      resources = @application.namespaces.flat_map{ |n| n.resources.values }
      resources.each do |config|
        define_resource_routes(router, config)
      end
    end

    def define_resource_routes(router, config)
      routes = proc { define_routes(router, config) }

        # Add on the namespace if required
      unless config.namespace.root?
        routes = proc { define_namespace(router, config) }
      end

      routes.call
    end

    def define_routes(router, config)
      if config.belongs_to?
        define_belongs_to_routes(router, config)
      else
        resource_routes(router, config)
      end
    end

    def resource_routes(router, config)
      case config
      when ::ActiveAdmin::Resource
        router.resources config.resource_name.route_key, only: config.defined_actions do
          define_actions(router, config)
        end
      when ::ActiveAdmin::Page
        page = config.underscored_resource_name
        router.get "/#{page}" => "#{page}#index"
        config.page_actions.each do |action|
          Array.wrap(action.http_verb).each do |verb|
            build_route router, verb, "/#{page}/#{action.name}" => "#{page}##{action.name}"
          end
        end
      else
        raise "Unsupported config class: #{config.class}"
      end
    end

    # Defines member and collection actions
    def define_actions(router, config)
      router.member do
        config.member_actions.each { |action| build_action(router, action) }
      end

      router.collection do
        config.collection_actions.each { |action| build_action(router, action) }
        router.post :batch_action if config.batch_actions_enabled?
      end
    end

    # Deals with +ControllerAction+ instances
    # Builds one route for each HTTP verb passed in
    def build_action(router, action)
      build_route(router, action.http_verb, action.name)
    end

    def build_route(router, verbs, *args)
      Array.wrap(verbs).each { |verb| router.send(verb, *args) }
    end

    def define_belongs_to_routes(router, config)
      # If it's optional, make the normal resource routes
      resource_routes(router, config) if config.belongs_to_config.optional?

      # Make the nested belongs_to routes
      # :only is set to nothing so that we don't clobber any existing routes on the resource
      router.resources config.belongs_to_config.target.resource_name.plural, only: [] do
        resource_routes(router, config)
      end
    end

    def define_namespace(router, config)
      router.namespace config.namespace.name, config.namespace.route_options.dup do
        define_routes(router, config)
      end
    end
  end
end
