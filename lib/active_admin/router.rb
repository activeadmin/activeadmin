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
    def apply(router)
      define_root_routes router
      define_resource_routes router
    end

    def define_root_routes(router)
      router.instance_exec @application.namespaces do |namespaces|
        namespaces.each do |namespace|
          if namespace.root?
            root namespace.root_to_options.merge(to: namespace.root_to)
          else
            namespace namespace.name do
              root namespace.root_to_options.merge(to: namespace.root_to, as: :root)
            end
          end
        end
      end
    end

    # Defines the routes for each resource
    def define_resource_routes(router)
      router.instance_exec @application.namespaces, self do |namespaces, aa_router|
        resources = namespaces.flat_map{ |n| n.resources.values }
        resources.each do |config|
          routes = aa_router.resource_routes(config)

          # Add in the parent if it exists
          if config.belongs_to?
            belongs_to = routes
            routes     = Proc.new do
              # If it's optional, make the normal resource routes
              instance_exec &belongs_to if config.belongs_to_config.optional?

              # Make the nested belongs_to routes
              # :only is set to nothing so that we don't clobber any existing routes on the resource
              resources config.belongs_to_config.target.resource_name.plural, only: [] do
                instance_exec &belongs_to
              end
            end
          end

          # Add on the namespace if required
          unless config.namespace.root?
            nested = routes
            routes = Proc.new do
              namespace config.namespace.name do
                instance_exec &nested
              end
            end
          end

          instance_exec &routes
        end
      end
    end

    def resource_routes(config)
      Proc.new do
        # Builds one route for each HTTP verb passed in
        build_route  = proc{ |verbs, *args|
          [*verbs].each{ |verb| send verb, *args }
        }
        # Deals with +ControllerAction+ instances
        build_action = proc{ |action|
          build_route.call(action.http_verb, action.name)
        }
        case config
        when ::ActiveAdmin::Resource
          resources config.resource_name.route_key, only: config.defined_actions do
            member do
              config.member_actions.each &build_action
            end

            collection do
              config.collection_actions.each &build_action
              post :batch_action if config.batch_actions_enabled?
            end
          end
        when ::ActiveAdmin::Page
          page = config.underscored_resource_name
          get "/#{page}" => "#{page}#index"
          config.page_actions.each do |action|
            build_route.call action.http_verb, "/#{page}/#{action.name}" => "#{page}##{action.name}"
          end
        else
          raise "Unsupported config class: #{config.class}"
        end
      end

    end
  end
end
