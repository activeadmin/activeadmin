module ActiveAdmin
  class Resource
    module Routes
      # @return [String] the path to this resource collection page
      # @example "/admin/posts"
      def route_collection_path(params = {})
        RouteBuilder.new(self).collection_path(params)
      end
      
      # @return [String] the path to this resource collection page
      # @param resource [ActiveRecord::Base] the instance we want the path of
      # @example "/admin/posts/1"
      def route_instance_path(resource)
        RouteBuilder.new(self).instance_path(resource)
      end

      # Returns the routes prefix for this config
      def route_prefix
        namespace.module_name.try(:underscore)
      end

      private

      class RouteBuilder
        def initialize(resource)
          @resource = resource
        end

        attr_reader :resource

        def collection_path(params)
          route, required_params = [], []

          route << resource.route_prefix

          if resource.belongs_to? && !resource.belongs_to_config.optional?
            name = resource.belongs_to_config.target.resource_name.singular
            route << name
            required_params << :"#{name}_id"
          end

          route << resource.controller.resources_configuration[:self][:route_collection_name]

          route << (route_uncountable? ? 'index_path' : 'path')

          route_name = route.compact.join("_").to_sym

          route_params = params.values_at(*required_params)
          routes.send(route_name, *route_params)
        end

        # @return [String] the path to this resource collection page
        # @param instance [ActiveRecord::Base] the instance we want the path of
        # @example "/admin/posts/1"
        def instance_path(instance)
          route = []
          route << resource.route_prefix

          if resource.belongs_to? && !resource.belongs_to_config.optional?
            belongs_to_name = resource.belongs_to_config.target.resource_name.singular
            route << belongs_to_name
          end

          route << resource.controller.resources_configuration[:self][:route_instance_name]
          route << 'path'

          route_name = route.compact.join('_').to_sym

          route_param = if resource.belongs_to? && !resource.belongs_to_config.optional?
                          belongs_to_name = resource.belongs_to_config.target.resource_name.singular
                          [instance.send(belongs_to_name).id, instance.id]
                        else
                          instance.id
                        end

          routes.send(route_name, *route_param)
        end


        def route_uncountable?
          config = resource.controller.resources_configuration[:self]

          config[:route_collection_name] == config[:route_instance_name]
        end

        def routes
          Rails.application.routes.url_helpers
        end
      end
    end
  end
end
