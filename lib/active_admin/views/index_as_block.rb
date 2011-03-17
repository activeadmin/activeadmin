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
    class IndexAsBlock < Renderer
      def to_html(page_config, collection)
        collection.collect do |obj|
          instance_exec(obj, &page_config.block)
        end.join.html_safe
      end
    end
  end
end
