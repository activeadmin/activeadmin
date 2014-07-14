module ActiveAdmin
  class Resource
    module Routes
      # @params params [Hash] of params: {study_id: 3}
      # @return [String] the path to this resource collection page
      # @example "/admin/posts"
      def route_collection_path(params = {})
        RouteBuilder.new(self).collection_path(params)
      end

      # @param resource [ActiveRecord::Base] the instance we want the path of
      # @return [String] the path to this resource collection page
      # @example "/admin/posts/1"
      def route_instance_path(resource)
        RouteBuilder.new(self).instance_path(resource)
      end

      # Returns the routes prefix for this config
      def route_prefix
        namespace.module_name.try(:underscore)
      end

      def route_uncountable?
        config = resources_configuration[:self]

        config[:route_collection_name] == config[:route_instance_name]
      end

      private

      class RouteBuilder
        def initialize(resource)
          @resource = resource
        end

        def collection_path(params)
          route_name = route_name(
            resource.resources_configuration[:self][:route_collection_name],
            (resource.route_uncountable? ? 'index_path' : 'path')
          )

          routes.public_send route_name, *route_collection_params(params)
        end

        # @return [String] the path to this resource collection page
        # @param instance [ActiveRecord::Base] the instance we want the path of
        # @example "/admin/posts/1"
        def instance_path(instance)
          route_name = route_name(resource.resources_configuration[:self][:route_instance_name])

          routes.public_send route_name, *route_instance_params(instance)
        end

        private

        attr_reader :resource

        def route_name(resource_path_name, suffix = 'path')
          route = []

          route << resource.route_prefix      # "admin"
          route += belongs_to_names
          route << resource_path_name         # "posts" or "post"
          route << suffix                     # "path" or "index path"

          route.compact.join('_').to_sym      # :admin_category_posts_path
        end


        # @return params to pass to instance path
        def route_instance_params(instance)
          belongs_to_names.reverse.reduce([instance]) do |arr,name| 
            arr + [arr.last.public_send(name)]
          end.map{|i| i.to_param }.reverse
        end

        def route_collection_params(params)
          belongs_to_names.map{|name| params[:"#{name}_id"]}
        end

        def nested?
          !required_belongs_to.empty?
        end

        def belongs_to_names
          required_belongs_to.map{|bc| bc.target.resource_name.singular }
        end

        def required_belongs_to
          if resource.belongs_to?
            resource.belongs_to_config.select{|bc| bc.required?} 
          else
            []
          end
        end

        def routes
          Rails.application.routes.url_helpers
        end
      end
    end
  end
end
