module ActiveAdmin
  module Helpers
    module Collection
      # Works around this issue: https://github.com/rails/rails/issues/7121
      #
      # GROUP BY + COUNT drops SELECT statement. This leads to SQL error when
      # the ORDER statement mentions a column defined in the SELECT statement.
      #
      # We remove the ORDER statement to work around this issue.
      def collection_size(collection=collection)
        size = collection.reorder("").count
        # when GROUP BY is used, AR returns Hash instead of Fixnum for .size
        size = size.size if size.kind_of?(Hash)

        size
      end

      def collection_is_empty?(collection=collection)
        collection_size(collection) == 0
      end
    end
  end
end
