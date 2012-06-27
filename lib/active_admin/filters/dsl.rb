module ActiveAdmin
  module Filters
    module DSL

      # For docs, please see ActiveAdmin::Filters::ResourceExtension#add_filter
      def filter(attribute, options = {})
        config.add_filter(attribute, options)
      end

    end
  end
end
