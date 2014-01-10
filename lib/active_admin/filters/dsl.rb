module ActiveAdmin
  module Filters
    module DSL

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
