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
      # Define any necessary dashboard routes
      router.instance_exec(@application.namespaces.values) do |namespaces|
        namespaces.each do |namespace|
          if namespace.root?
            match '/' => 'dashboard#index', :as => 'dashboard'
          else
            name = namespace.name.to_s
            match name => "#{name}/dashboard#index", :as => "#{name}_dashboard"
          end
        end
      end

      router.instance_exec(@application.namespaces) do |namespaces|
        namespaces.each do |namespace_name, namespace|
          active_admin_namespace(namespace) do
            namespace.resources.each do |resource_name, resource|
              children_resources = namespace.resources.values.select { |children| children.belongs_to_config.map(&:target).include?(resource) }
              active_admin_resources(resource) do
                children_resources.each do |children|
                  active_admin_resources(children)
                end
              end
            end
          end
        end
      end
    end

    module ::ActionDispatch::Routing
      class Mapper
        def active_admin_namespace(namespace, &block)
          namespace.root? ? yield : namespace(namespace.name, &block)
        end

        def active_admin_resources(resource, &block)
          resources(resource.underscored_resource_name.pluralize) do
            active_admin_member_actions(resource)
            active_admin_collection_actions(resource)
            yield if block_given?
          end
        end

        def active_admin_member_actions(resource)
          member do
            resource.member_actions.each do |action|
              # eg: get :comment
              send(action.http_verb, action.name)
            end
          end
        end

        def active_admin_collection_actions(resource)
          collection do
            resource.collection_actions.each do |action|
              send(action.http_verb, action.name)
            end
          end
        end
      end
    end
  end
end
