module ActiveAdmin
  class Config
    module Naming
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
