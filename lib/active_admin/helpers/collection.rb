# frozen_string_literal: true
module ActiveAdmin
  module Helpers
    module Collection
      # 1. removes `select` and `order` to prevent invalid SQL
      # 2. correctly handles the Hash returned when `group by` is used
      # 3. Avoids duplicative COUNT/subquery_for_count queries
      def collection_size(c = collection)
        # 'length' avoids count query on unloaded collection with a limit_value
        return c.length if c.is_a?(Array) || c.limit_value.present?

        c = c.except :select, :order
        c.group_values.present? ? c.size.size : c.size
      end

      def collection_is_empty?(c = collection)
        collection_size(c) == 0
      end
    end
  end
end
