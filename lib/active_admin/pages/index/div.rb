module ActiveAdmin
  module Pages
    class Index

      # Simplest rendering possible. Render each element in the collection as
      # a div and render the block inside that.
      #
      # Example:
      #
      #   ActiveAdmin.register Post do
      #     index :as => :div do |post|
      #       render 'post', :post => post # render the post partial (app/views/admin/posts/_post)
      #     end
      #   end
      class Div < Renderer
        def to_html(page_config, collection)
          wrap_with_pagination(collection, :entry_name => active_admin_config.resource_name) do
            collection.collect do |obj|
              div_for obj do
                instance_exec(obj, &page_config.block)
              end
            end.join
          end          
        end
      end
    end
  end
end
