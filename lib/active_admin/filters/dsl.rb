module ActiveAdmin
  module Filters
    module DSL

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#add_filter
      def filter(attribute, options = {})
        config.add_filter(attribute, options)
      end

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#delete_filter
      def remove_filter(attribute)
        config.remove_filter(attribute)
      end
    end
  end
end
