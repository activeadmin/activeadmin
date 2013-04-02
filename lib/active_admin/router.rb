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
      define_basic_routes router
      define_resource_routes router
    end

    # Define any necessary dashboard routes and root
    def define_basic_routes(router)
      router.instance_exec(@application.namespaces.values, self) do |namespaces, aa_router|
        namespaces.each do |namespace|
          if namespace.root?
            instance_eval &aa_router.root_and_dashboard_routes(namespace)
          else
            namespace(namespace.name) do
              instance_eval &aa_router.root_and_dashboard_routes(namespace)
            end
          end
        end
      end
    end

    def root_and_dashboard_routes(namespace)
      Proc.new do
        root :to => (namespace.root_to || "dashboard#index")
        if ActiveAdmin::Dashboards.built?
          match '/dashboard' => 'dashboard#index', :as => 'dashboard'
        end
      end
    end

    # Define the routes for each resource
    def define_resource_routes(router)
      resource_routes = method(:resource_routes)

      router.instance_exec(@application.namespaces, self) do |namespaces, aa_router|
        resources = namespaces.values.collect{|n| n.resources.resources }.flatten
        resources.each do |config|
          route_definition_block = aa_router.resource_routes(config)

          # Add in the parent if it exists
          if config.belongs_to?
            routes_for_belongs_to = route_definition_block.dup
            route_definition_block = Proc.new do
              # If its optional, make the normal resource routes
              instance_eval &routes_for_belongs_to if config.belongs_to_config.optional?

              # Make the nested belongs_to routes
              # :only is set to nothing so that we don't clobber any existing routes on the resource
              resources config.belongs_to_config.target.resource_name.plural, :only => [] do
                instance_eval &routes_for_belongs_to
              end
            end
          end

          # Add on the namespace if required
          unless config.namespace.root?
            routes_in_namespace = route_definition_block.dup
            route_definition_block = Proc.new do
              namespace config.namespace.name do
                instance_eval(&routes_in_namespace)
              end
            end
          end

          instance_eval &route_definition_block
        end
      end
    end

    def resource_routes(config)
      Proc.new do
        case config
        when Resource
          resources config.resource_name.route_key, :only => config.defined_actions do
            # Define any member actions
            member do
              config.member_actions.each do |action|
                [*action.http_verb].each do |http_verb|
                  # eg: get :comment
                  send(http_verb, action.name)
                end
              end
            end

            # Define any collection actions
            collection do
              config.collection_actions.each do |action|
                send(action.http_verb, action.name)
              end

              post :batch_action
            end
          end
        when Page
          match "/#{config.underscored_resource_name}" => "#{config.underscored_resource_name}#index"
          config.page_actions.each do |action|
            match "/#{config.underscored_resource_name}/#{action.name}" => "#{config.underscored_resource_name}##{action.name}", :via => action.http_verb
          end
        else
          raise "Unsupported config class: #{config.class}"
        end
      end

    end
  end
end
