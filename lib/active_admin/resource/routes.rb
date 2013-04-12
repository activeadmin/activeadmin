module ActiveAdmin
  class Resource
    module Routes

      # Returns the routes prefix for this config
      def route_prefix
        namespace.module_name.try(:underscore)
      end

      def route_uncountable?
        controller.resources_configuration[:self][:route_collection_name] ==
              controller.resources_configuration[:self][:route_instance_name]
      end

      # @return [String] the path to this resource collection page
      # @example "/admin/posts"
      def route_collection_path(params = {})
        route, required_params = [], []

        route << route_prefix

        if belongs_to? && !belongs_to_config.optional?
          name = belongs_to_config.target.resource_name.singular
          route << name
          required_params << :"#{name}_id"
        end

        route << controller.resources_configuration[:self][:route_collection_name]

        route << (route_uncountable? ? 'index_path' : 'path')

        route_name = route.compact.join("_").to_sym

        route_params = params.values_at(*required_params)
        routes.send(route_name, *route_params)
      end

      # @return [String] the path to this resource collection page
      # @param resource [ActiveRecord::Base] the instance we want the path of
      # @example "/admin/posts/1"
      def route_instance_path(resource)
        route_name = [route_prefix, controller.resources_configuration[:self][:route_instance_name], 'path'].compact.join('_').to_sym

        routes.send(route_name, resource)
      end


      private

      def routes
        Rails.application.routes.url_helpers
      end

    end
  end
end
