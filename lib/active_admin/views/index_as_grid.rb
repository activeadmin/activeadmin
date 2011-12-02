module ActiveAdmin
  module Views

     # = Index as a Grid
     #
     # Sometimes you want to display the index screen for a set of resources as a grid
     # (possibly a grid of thumbnail images). To do so, use the :grid option for the
     # index block.
     #
     #     index :as => :grid do |product|
     #       link_to(image_tag(product.image_path), admin_products_path(product))
     #     end
     #
     # The block is rendered within a cell in the grid once for each resource in the
     # collection. The resource is passed into the block for you to use in the view.
     #
     # You can customize the number of colums that are rendered using the columns
     # option:
     #
     #     index :as => :grid, :columns => 5 do |product|
     #       link_to(image_tag(product.image_path), admin_products_path(product))
     #     end
     #
     class IndexAsGrid < ActiveAdmin::Component

      def build(page_presenter, collection)
        @page_presenter = page_presenter
        @collection = collection
        add_class "index"
        build_table
      end

      def number_of_columns
        @page_presenter[:columns] || default_number_of_columns
      end

      protected

      def build_table
        resource_selection_toggle_panel
        table :class => "index_grid" do
          collection.in_groups_of(number_of_columns).each do |group|
            build_row(group)
          end
        end
      end

      def build_row(group)
        tr do
          group.each do |item|
            item ? build_item(item) : build_empty_cell
          end
        end
      end

      def build_item(item)
        td :for => item do
          instance_exec(item, &@page_presenter.block)
        end
      end

      def build_empty_cell
        td '&nbsp;'.html_safe
      end

      def default_number_of_columns
        3
      end

    end
  end
end
