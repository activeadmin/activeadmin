module ActiveAdmin
  module Filters
    module DSL

      def filters(*attributes)
        options = attributes.extract_options!

        attributes.each do |attributes|
          attributes = {attributes => {}} unless attributes.is_a?(Hash)

          attributes.each do |attribute, attribute_options|
            filter(attribute, options.merge(attribute_options))
          end
        end
      end

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#add_filter
      def filter(attribute, options = {})
        config.add_filter(attribute, options)
      end

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#remove_filter
      def remove_filter(*attributes)
        config.remove_filter(*attributes)
      end

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#preserve_default_filters!
      def preserve_default_filters!
        config.preserve_default_filters!
      end
    end
  end
end
