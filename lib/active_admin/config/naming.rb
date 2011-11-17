module ActiveAdmin
  class Config
    module Naming
      def resource_name
        raise "Subclasses of Config should implement resource_name"
      end

      def plural_resource_name
        raise "Subclasses of Config should implement plural_resource_name"
      end

      def underscored_resource_name
        raise "Subclasses of Config should implement underscored_resource_name"
      end

      # A camelized safe representation for this resource
      def camelized_resource_name
        underscored_resource_name.camelize
      end

      # Returns the plural and underscored version of this resource. Useful for element id's.
      def plural_underscored_resource_name
        plural_resource_name.underscore.gsub(/\s/, '_')
      end
    end
  end
end
