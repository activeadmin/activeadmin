module ActiveAdmin
  module Views
    class IndexAsGrid < ActiveAdmin::Component

      def build(page_config, collection)
        @page_config = page_config
        @collection = collection
        build_table
      end

      def number_of_columns
        @page_config[:columns] || default_number_of_columns
      end

      protected

      def build_table
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
          instance_exec(item, &@page_config.block)
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
