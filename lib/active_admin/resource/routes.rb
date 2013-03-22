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

      # Returns a symbol for the route to use to get to the
      # collection of this resource
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

      private

      def routes
        Rails.application.routes.url_helpers
      end

    end
  end
end
