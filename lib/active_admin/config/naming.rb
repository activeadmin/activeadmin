module ActiveAdmin
  class Config
    module Naming
      # @return [String] Example: "My Post"
      def resource_name
        raise "Subclasses of Config should implement resource_name"
      end

      # @return [String] Example: "My Posts"
      def plural_resource_name
        raise "Subclasses of Config should implement plural_resource_name"
      end

      # A camelized safe representation for this resource
      def camelized_resource_name
        resource_name.titleize.gsub(' ', '')
      end

      def plural_camelized_resource_name
        plural_resource_name.titleize.gsub(' ', '')
      end

      # An underscored safe representation internally for this resource
      def underscored_resource_name
        camelized_resource_name.underscore
      end

      # Returns the plural and underscored version of this resource. Useful for element id's.
      def plural_underscored_resource_name
        plural_camelized_resource_name.underscore
      end

    end
  end
end
