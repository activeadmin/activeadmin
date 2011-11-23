module ActiveAdmin
  module Views
    class TableFor < Arbre::HTML::Table
      builder_method :table_for

      def tag_name
        'table'
      end

      def build(collection, options = {})
        @sortable = options.delete(:sortable)
        @resource_class = options.delete(:i18n)
        @collection = collection
        @columns = []
        build_table
        super(options)
      end

      def column(*args, &block)
        options = default_options.merge(args.last.is_a?(::Hash) ? args.pop : {})
        title = args[0]
        data  = args[1] || args[0]

        col = Column.new(title, data, options, &block)
        @columns << col

        # Build our header item
        within @header_row do
          build_table_header(col)
        end

        # Add a table cell for each item
        @collection.each_with_index do |item, i|
          within @tbody.children[i] do
            build_table_cell(col, item)
          end
        end
      end

      def sortable?
        @sortable
      end

      # Returns the columns to display based on the conditional block
      def visible_columns
        @visible_columns ||= @columns.select{|col| col.display_column? }
      end

      protected

      def build_table
        build_table_head
        build_table_body
      end

      def build_table_head
        @thead = thead do
          @header_row = tr
        end
      end

      def build_table_header(col)
        if sortable? && col.sortable?
          build_sortable_header_for(col.title, col.sort_key)
        else
          th(col.title, :class => (col.data.to_s.downcase.underscore if col.data.is_a?(Symbol)))
        end
      end

      def build_sortable_header_for(title, sort_key)
        classes = Arbre::HTML::ClassList.new(["sortable"])
        if current_sort[0] == sort_key
          classes << "sorted-#{current_sort[1]}"
        end
        
        header_class = title.downcase.underscore
        
        classes << header_class

        th :class => classes do
          link_to(title, params.merge(:order => "#{sort_key}_#{order_for_sort_key(sort_key)}").except(:page))
        end
      end

      def build_table_body
        @tbody = tbody do
          # Build enough rows for our collection
          @collection.each{|_| tr(:class => cycle('odd', 'even'), :id => dom_id(_)) }
        end
      end

      def build_table_cell(col, item)
        td(:class => (col.data.to_s.downcase if col.data.is_a?(Symbol))) do
          rvalue = call_method_or_proc_on(item, col.data, :exec => false)
          if col.data.is_a?(Symbol)
            rvalue = pretty_format(rvalue)
          end
          rvalue
        end
      end

      # Returns an array for the current sort order
      #   current_sort[0] #=> sort_key
      #   current_sort[1] #=> asc | desc
      def current_sort
        @current_sort ||= if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
          [$1,$2]
        else
          []
        end
      end

      # Returns the order to use for a given sort key
      #
      # Default is to use 'desc'. If the current sort key is
      # 'desc' it will return 'asc'
      def order_for_sort_key(sort_key)
        current_key, current_order = current_sort
        return 'desc' unless current_key == sort_key
        current_order == 'desc' ? 'asc' : 'desc'
      end

      def default_options
        {
          :i18n => @resource_class
        }
      end

      class Column

        attr_accessor :title, :data

        def initialize(*args, &block)
          @options = default_options.merge(args.last.is_a?(::Hash) ? args.pop : {})
          @title = pretty_title args[0]
          @data  = args[1] || args[0]
          @data = block if block
        end

        def sortable?
          if @data.is_a?(Proc)
            [String, Symbol].include?(@options[:sortable].class)
          else
            @options[:sortable]
          end
        end

        #
        # Returns the key to be used for sorting this column
        #
        # Defaults to the column's method if its a symbol
        #   column :username
        #   # => Sort key will be set to 'username'
        #
        # You can set the sort key by passing a string or symbol
        # to the sortable option:
        #   column :username, :sortable => 'other_column_to_sort_on'
        #
        # If you pass a block to be rendered for this column, the column
        # will not be sortable unless you pass a string to sortable to
        # sort the column on:
        #
        #   column('Username', :sortable => 'login'){ @user.pretty_name }
        #   # => Sort key will be 'login'
        #
        def sort_key
          if @options[:sortable] == true || @options[:sortable] == false
            @data.to_s
          else
            @options[:sortable].to_s
          end
        end

        private

        def pretty_title(raw)
          if raw.is_a?(Symbol)
            if @options[:i18n] && @options[:i18n].respond_to?(:human_attribute_name) && human_name = @options[:i18n].human_attribute_name(raw)
              raw = human_name
            end

            raw.to_s.titleize
          else
            raw
          end
        end

        def default_options
          {
            :sortable => true
          }
        end

      end
    end
  end
end
