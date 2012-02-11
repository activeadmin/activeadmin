module ActiveAdmin
  module Views

    # = Columns Component
    #
    # The Columns component allows you draw content into scalable columns. All
    # you need to do is define the number of columns and the component will
    # take care of the rest.
    #
    # == Simple Columns
    #
    # To display columns, use the #columns method. Within the block, call the 
    # #column method to create a new column.
    #
    # To createa a two column layout:
    #
    #     colums do
    #       column do
    #         span "Column # 1
    #       end
    #       column do
    #         span "Column # 2
    #       end
    #     end
    #
    #
    # == Multiple Span Columns
    #
    # To make a column span multiple, pass the :span option to the column method:
    #
    #     colums do
    #       column :span => 2 do
    #         span "Column # 1
    #       end
    #       column do
    #         span "Column # 2
    #       end
    #     end
    #
    # By default, each column spans 1 column. So the above layout would have 2 columns,
    # the first being 2 time bigger than the second.
    #
    #
    # == Max and Mix Column Sizes
    #
    # Active Admin is a fluid width layout, which means that columns are all defined
    # using percentages. Sometimes this can cause issues if you don't want a column
    # to shrink or expand past a certain point.
    #
    # To overcome this, columns include a :max_width and :min_width option.
    #
    #     colums do
    #       column :max_width => "200px", :min_width => "100px" do
    #         span "Column # 1
    #       end
    #       column do
    #         span "Column # 2
    #       end
    #     end
    #
    # Now the first column will not grow bigger than 200px and will not shrink smaller
    # than 100px.
    class Columns < ActiveAdmin::Component
      builder_method :columns


      # For documentation, please take a look at Column#build
      def column(*args, &block)
        insert_tag Column, *args, &block
      end

      # Override add child to set widths
      def add_child(*)
        super
        calculate_columns!
      end

      protected

      # Override the closing tag to include a clear
      def closing_tag
        "<div style=\"clear:both;\"></div>" + super
      end

      def margin_size
        2
      end

      # Calculate our columns sizes and margins
      def calculate_columns!
        span_count = columns_span_count
        columns_count = children.size

        all_margins_width = margin_size * (span_count - 1)
        column_width = (100.00 - all_margins_width) / span_count

        children.each_with_index do |col, i|
          is_last_column = i == (columns_count - 1)
          col.set_column_styles(column_width, margin_size, is_last_column)
        end
      end

      def columns_span_count
        count = 0
        children.each {|column| count += column.span_size }

        count
      end

    end

    class Column < ActiveAdmin::Component

      attr_accessor :span_size, :max_width, :min_width

      # @param [Hash] options An options hash for the column
      #
      # @options options [Integer] :span The columns this column should span
      def build(options = {})
        options = options.dup
        @span_size = options.delete(:span) || 1
        @max_width = options.delete(:max_width)
        @min_width = options.delete(:min_width)

        super(options)
      end

      def set_column_styles(column_width, margin_width, is_last_column = false)
        column_with_span_width = (span_size * column_width) + ((span_size - 1) * margin_width)

        styles = []

        styles << "width: #{column_with_span_width}%;"

        if max_width
          styles << "max-width: #{max_width};"
        end

        if min_width
          styles << "min-width: #{min_width};"
        end

        styles << "margin-right: #{margin_width}%;" unless is_last_column

        set_attribute :style, styles.join(" ")
      end

    end
  end
end
