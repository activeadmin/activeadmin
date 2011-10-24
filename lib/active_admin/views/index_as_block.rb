module ActiveAdmin
  module Views

    # = Index as a Block
    #
    # If you want to fully customize the display of your resources on the index
    # screen, Index as a Block allows you to render a block of content for each
    # resource.
    #
    #     index :as => :block do |product|
    #       div :for => product do
    #         resource_selection_cell product
    #         h2 auto_link(product.title)
    #         div do
    #           simple_format product.description
    #         end
    #       end
    #     end
    #
    class IndexAsBlock < ActiveAdmin::Component

      def build(page_config, collection)
        add_class "index"
        resource_selection_toggle_panel
        collection.each do |obj|
          instance_exec(obj, &page_config.block)
        end
      end

    end
  end
end
