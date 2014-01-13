module ActiveAdmin
  module Helpers
    module Collection
      # Works around this issue: https://github.com/rails/rails/issues/7121
      #
      # GROUP BY + COUNT drops SELECT statement. This leads to SQL error when
      # the ORDER statement mentions a column defined in the SELECT statement.
      #
      # We remove the ORDER statement to work around this issue.
      #
      # If you use includes method on collection you will potentially call two queries for each
      # association. For example, if you ORDER BY created_at DESC, calls
      # to this method will remove the order clause and execute the query bringing
      # back results sorted by id ASC (which is probably equivalent to created_at ASC)
      # and all the associations for that result set will be eager loaded as well as
      # the ones for your intended result set sorted by created_at DESC.
      #
      # Example:
      #   class Company < ActiveRecord::Base
      #     has_many :users
      #   end
      #
      #   ActiveAdmin.register Company do
      #     config.per_page = 5
      #     config.sort_order = 'created_at_desc'
      #     
      #     actions :index
      #
      #     controller do
      #       def index
      #         index! do |format|
      #           @companies = collection.includes(:users); format.html
      #         end
      #       end
      #     end
      #
      #     # rest of admin code
      #
      #   SELECT * FROM companies ORDER BY created_at DESC LIMIT 5 OFFSET 0; # ids: 10, 9, 8, 7, 6
      #   SELECT * FROM users WHERE company_id IN (10,9,8,7,6)
      #
      #   # now collection_size is called (e.g. from #items_in_collection?
      #
      #   SELECT * FROM companies LIMIT 5 OFFSET 0; # ids: 1,2,3,4,5
      #   SELECT * FROM users WHERE company_id IN (1,2,3,4,5)
      #
      #   So we should only use this work around if the #group method was called on the
      #   ActiveRecord::Relation. Or else proceed as normal.
      def collection_size(collection=collection)
        if collection.grouped_values.present?
          size = collection.reorder("").count
          # when GROUP BY is used, AR returns Hash instead of Fixnum for .size
          size = size.size if size.kind_of?(Hash)

          size
        else
          collection.count
        end
      end

      def collection_is_empty?(collection=collection)
        collection_size(collection) == 0
      end
    end
  end
end
