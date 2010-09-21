module ActiveAdmin
  module Pages
    class Index

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
      class Block < Renderer
        def to_html(page_config, collection)
          wrap_with_pagination(collection, :entry_name => active_admin_config.resource_name) do
            collection.collect do |obj|
              instance_exec(obj, &page_config.block)
            end.join
          end          
        end
      end
    end
  end
end
