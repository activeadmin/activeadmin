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
      # Define any necessary dashboard routes and root
      router.instance_exec(@application.namespaces.values) do |namespaces|
        namespaces.each do |namespace|
          root_and_dashboard_routes = Proc.new do
            root :to => (namespace.root_to || "dashboard#index")
            if ActiveAdmin::Dashboards.built?
              match '/dashboard' => 'dashboard#index', :as => 'dashboard'
            end
          end

          if namespace.root?
            instance_eval &root_and_dashboard_routes
          else
            namespace(namespace.name) do
              instance_eval &root_and_dashboard_routes
            end
          end
        end
      end

      # Now define the routes for each resource
      router.instance_exec(@application.namespaces) do |namespaces|
        resources = namespaces.values.collect{|n| n.resources.resources }.flatten
        resources.each do |config|

          # Define the block the will get eval'd within the namespace
          route_definition_block = Proc.new do
            case config
            when Resource
              resources config.resource_name.route_key, :only => config.defined_actions do
                # Define any member actions
                member do
                  config.member_actions.each do |action|
                    # eg: get :comment
                    send(action.http_verb, action.name)
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

              # Batch action path is not nested.
              if config.is_a?(Resource)
                resources config.resource_name.route_key, :only => config.defined_actions do
                  collection do
                    post :batch_action
                  end
                end
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
  end
end
