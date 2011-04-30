module ActiveAdmin
  module Views

    # Simplest rendering possible. Calls the block for each element in the collection.
    #
    # Example:
    #
    #   ActiveAdmin.register Post do
    #     index :as => :block do |post|
    #       # render the post partial (app/views/admin/posts/_post)
    #       render 'post', :post => post 
    #     end
    #   end
    class IndexAsBlock < ActiveAdmin::Component

      def build(page_config, collection)
        collection.each do |obj|
          instance_exec(obj, &page_config.block)
        end
      end

    end
  end
end
