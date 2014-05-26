module ActiveAdmin
  class Router
    class ResourceRoutes
      attr_reader :route, :config

      def initialize(route, config)
        @route = route
        @config = config
      end

      def call
        define_namespace do
          if config.belongs_to?
            # Add in the parent if it exists
            define_routes if config.belongs_to_config.optional?
            define_belongs_to_routes
          else
            define_routes
          end
        end
      end

      private

      # Defines all routes: resource and page
      def define_routes
        case config
        when ::ActiveAdmin::Resource
          route.public_send resource_type, resource_name, only: config.defined_actions do
            define_actions
          end
        when ::ActiveAdmin::Page
          page = config.underscored_resource_name

          route.get "/#{page}" => "#{page}#index"

          config.page_actions.each do |action|
            build_route(action.http_verb, "/#{page}/#{action.name}" => "#{page}##{action.name}")
          end
        else
          raise "Unsupported config class: #{config.class}"
        end
      end

      # Make the nested belongs_to routes
      def define_belongs_to_routes
        # :only is set to nothing so that we don't clobber any existing routes on the resource
        route.resources config.belongs_to_config.target.resource_name.plural, only: [] do
          define_routes
        end
      end

      # Add on the namespace if required
      def define_namespace
        if config.namespace.root?
          yield
        else
          route.namespace config.namespace.name do
            yield
          end
        end
      end

      def resource_type
        singleton_belongs_to? ? :resource : :resources
      end

      def resource_name
        config.resource_name.public_send(singleton_belongs_to? ? :singular : :plural)
      end

      # Builds one route for each HTTP verb passed in
      def build_route(verbs, *args)
        [*verbs].each { |verb| route.send(verb, *args) }
      end

      # Deals with +ControllerAction+ instances
      def build_action(action)
        build_route(action.http_verb, action.name)
      end


      # Defines member and collection actions
      def define_actions
        route.member do
          config.member_actions.each { |v| build_action(v) }
        end

        route.collection do
          config.collection_actions.each { |v| build_action(v) }
          route.post :batch_action if config.batch_actions_enabled?
        end
      end

      # Check if a child route singleton
      def singleton_belongs_to?
        config.belongs_to? &&
          config.belongs_to_config.singleton?
      end
    end
  end
end
