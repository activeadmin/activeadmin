module ActiveAdmin
  # @private
  class Router
    attr_reader :namespaces, :router

    def initialize(router:, namespaces:)
      @router = router
      @namespaces = namespaces
    end

    def apply
      define_root_routes
      define_resources_routes
    end

    private

    def define_root_routes
      namespaces.each do |namespace|
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
    def define_resources_routes
      resources = namespaces.flat_map { |n| n.resources.values }
      resources.each do |config|
        define_resource_routes(config)
      end
    end

    def define_resource_routes(config)
      if config.namespace.root?
        define_routes(config)
      else
        # Add on the namespace if required
        define_namespace(config)
      end
    end

    def define_routes(config)
      if config.belongs_to?
        define_belongs_to_routes(config)
      else
        page_or_resource_routes(config)
      end
    end

    def page_or_resource_routes(config)
      config.is_a?(Page) ? page_routes(config) : resource_routes(config)
    end

    def resource_routes(config)
      router.resources config.resource_name.route_key, only: config.defined_actions do
        define_actions(config)
      end
    end

    def page_routes(config)
      page = config.underscored_resource_name
      router.get "/#{page}" => "#{page}#index"
      config.page_actions.each do |action|
        Array.wrap(action.http_verb).each do |verb|
          build_route(verb, "/#{page}/#{action.name}" => "#{page}##{action.name}")
        end
      end
    end

    # Defines member and collection actions
    def define_actions(config)
      router.member do
        config.member_actions.each { |action| build_action(action) }
      end

      router.collection do
        config.collection_actions.each { |action| build_action(action) }
        router.post :batch_action if config.batch_actions_enabled?
      end
    end

    # Deals with +ControllerAction+ instances
    # Builds one route for each HTTP verb passed in
    def build_action(action)
      build_route(action.http_verb, action.name)
    end

    def build_route(verbs, *args)
      Array.wrap(verbs).each { |verb| router.send(verb, *args) }
    end

    def define_belongs_to_routes(config)
      # If it's optional, make the normal resource routes
      page_or_resource_routes(config) if config.belongs_to_config.optional?

      # Make the nested belongs_to routes
      # :only is set to nothing so that we don't clobber any existing routes on the resource
      router.resources config.belongs_to_config.target.resource_name.plural, only: [] do
        page_or_resource_routes(config)
      end
    end

    def define_namespace(config)
      router.namespace config.namespace.name, config.namespace.route_options.dup do
        define_routes(config)
      end
    end
  end
end
