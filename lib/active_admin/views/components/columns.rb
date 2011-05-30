module ActiveAdmin
  module Views

    class Columns < ActiveAdmin::Component
      builder_method :columns

      def column(*args, &block)
        insert_tag Column, *args, &block
      end

      # Override add child to set widths
      def add_child(*)
        super
        calculate_columns!
      end

      protected

      def margin_size
        2
      end

      def calculate_columns!
        # Calculate our columns sizes and margins
        count = children.size
        margins_width = margin_size * (count - 1)
        column_width = (100.00 - margins_width) / count

        # Convert to an integer if its not a float
        column_width = column_width.to_i == column_width ? column_width.to_i : column_width

        children.each_with_index do |col, i|
          col.set_attribute :style, "width: #{column_width}%;"
          col.attr(:style) << " margin-right: #{margin_size}%;" unless i == (count - 1)
        end
      end

      def to_html
        super.to_s + "<div style=\"clear:both;\"></div>".html_safe
      end

    end

    class Column < ActiveAdmin::Component
    end
  end
end
