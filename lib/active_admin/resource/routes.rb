module ActiveAdmin
  class Resource
    module Routes
      # @param params [Hash] of params: { study_id: 3 }
      # @return [String] the path to this resource collection page
      # @example "/admin/posts"
      def route_collection_path(params = {}, additional_params = {})
        RouteBuilder.new(self).collection_path(params, additional_params)
      end

      def route_batch_action_path(params = {}, additional_params = {})
        RouteBuilder.new(self).batch_action_path(params, additional_params)
      end

      # @param resource [ActiveRecord::Base] the instance we want the path of
      # @return [String] the path to this resource collection page
      # @example "/admin/posts/1"
      def route_instance_path(resource, additional_params = {})
        RouteBuilder.new(self).instance_path(resource, additional_params)
      end

      def route_edit_instance_path(resource, additional_params = {})
        RouteBuilder.new(self).edit_instance_path(resource, additional_params)
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

        def collection_path(params, additional_params = {})
          route_name = route_name(
            resource.resources_configuration[:self][:route_collection_name],
            suffix: (resource.route_uncountable? ? "index_path" : "path")
          )

          routes.public_send route_name, *route_collection_params(params), additional_params
        end

        def batch_action_path(params, additional_params = {})
          route_name = route_name(
            resource.resources_configuration[:self][:route_collection_name],
            action: :batch_action,
            suffix: (resource.route_uncountable? ? "index_path" : "path")
          )
          query = params.slice(:q, :scope)
          query = query.permit! if query.respond_to? :permit!
          query = query.to_h if Rails::VERSION::MAJOR >= 5
          routes.public_send route_name, *route_collection_params(params), additional_params.merge(query)
        end

        # @return [String] the path to this resource collection page
        # @param instance [ActiveRecord::Base] the instance we want the path of
        # @example "/admin/posts/1"
        def instance_path(instance, additional_params = {})
          route_name = route_name(resource.resources_configuration[:self][:route_instance_name])

          routes.public_send route_name, *route_instance_params(instance), additional_params
        end

        # @return [String] the path to the edit page of this resource
        # @param instance [ActiveRecord::Base] the instance we want the path of
        # @example "/admin/posts/1/edit"
        def edit_instance_path(instance, additional_params = {})
          path = resource.resources_configuration[:self][:route_instance_name]
          route_name = route_name(path, action: :edit)

          routes.public_send route_name, *route_instance_params(instance), additional_params
        end

        private

        attr_reader :resource

        def route_name(resource_path_name, options = {})
          suffix = options[:suffix] || "path"
          route = []

          route << options[:action]           # "edit" or "new"
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
          Helpers::Routes
        end
      end
    end
  end
end
