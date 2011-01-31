module ActiveAdmin
  module ViewHelpers
    module TableHelper

      # Helper to render a table for a collection
      def table_for(collection, options = {}, &block)
        ActiveAdmin::TableBuilder.new(&block).to_html(self, collection, options)
      end

    end
  end
end
