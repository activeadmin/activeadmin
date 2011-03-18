module ActiveAdmin
  module Views
    class IndexAsGrid < Renderer

      def to_html(page_config, collection)
        @page_config = page_config
        columns = page_config[:columns] || default_columns

        content_tag :table, :class => "index_grid" do
          collection.in_groups_of(columns).collect do |group|
            render_row(group)
          end.join.html_safe
        end
      end

      protected

      def render_row(group)
        content_tag :tr do
          group.collect do |item|
            item ? render_item(item) : render_empty_cell
          end.join.html_safe
        end
      end

      def render_item(item)
        content_tag_for :td, item do
          instance_exec(item, &@page_config.block)
        end
      end

      def render_empty_cell
        content_tag(:td, '&nbsp;'.html_safe)
      end

      def default_columns
        3
      end

    end
  end
end
