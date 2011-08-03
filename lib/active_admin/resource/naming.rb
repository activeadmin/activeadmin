module ActiveAdmin
  class Resource
    module Naming

      # An underscored safe representation internally for this resource
      def underscored_resource_name
        @underscored_resource_name ||= if @options[:as]
          @options[:as].gsub(' ', '').underscore.singularize
        else
          resource.name.gsub('::','').underscore
        end
      end

      # A camelized safe representation for this resource
      def camelized_resource_name
        underscored_resource_name.camelize
      end

      # Returns the name to call this resource.
      # By default will use resource.model_name.human
      def resource_name
        @resource_name ||= if @options[:as] || !resource.respond_to?(:model_name)
          underscored_resource_name.titleize
        else
          resource.model_name.human.titleize
        end
      end

      # Returns the plural version of this resource
      def plural_resource_name
        @plural_resource_name ||= if @options[:as] || !resource.respond_to?(:model_name)
          @resource_name.pluralize
        else
          resource.model_name.human(:count => 3)
        end
      end

    end
  end
end
