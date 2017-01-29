module ActiveAdmin
  module Helpers
    module Collection
      # 1. removes `select` and `order` to prevent invalid SQL
      # 2. correctly handles the Hash returned when `group by` is used
      def collection_size(c = collection)
        return c.count if c.is_a?(Array)

        c = c.except :select, :order

        c.group_values.present? ? c.count.count : c.count
      end

      def collection_is_empty?(c = collection)
        collection_size(c) == 0
      end
    end
  end
end
