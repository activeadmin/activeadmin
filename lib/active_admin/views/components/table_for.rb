module ActiveAdmin
  module Views
    class TableFor < Arbre::HTML::Table
      builder_method :table_for

      def tag_name
        'table'
      end

      def build(obj, *attrs)
        options         = attrs.extract_options!
        @sortable       = options.delete(:sortable)
        @collection     = obj.respond_to?(:each) && !obj.is_a?(Hash) ? obj : [obj]
        @resource_class = options.delete(:i18n)
        @resource_class ||= @collection.klass if @collection.respond_to? :klass
        @columns        = []
        @row_class      = options.delete(:row_class)

        build_table
        super(options)
        columns(*attrs)
      end

      def columns(*attrs)
        attrs.each {|attr| column(attr) }
      end

      def column(*args, &block)
        options = default_options.merge(args.extract_options!)
        title = args[0]
        data  = args[1] || args[0]

        col = Column.new(title, data, @resource_class, options, &block)
        @columns << col

        # Build our header item
        within @header_row do
          build_table_header(col)
        end

        # Add a table cell for each item
        @collection.each_with_index do |item, i|
          within @tbody.children[i] do
            build_table_cell col, item
          end
        end
      end

      def sortable?
        !!@sortable
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
        classes  = Arbre::HTML::ClassList.new
        sort_key = sortable? && col.sortable? && col.sort_key
        params   = request.query_parameters.except :page, :order, :commit, :format

        classes << 'sortable'                         if sort_key
        classes << "sorted-#{current_sort[1]}"        if sort_key && current_sort[0] == sort_key
        classes << col.html_class

        if sort_key
          th class: classes do
            link_to col.pretty_title, params: params, order: "#{sort_key}_#{order_for_sort_key(sort_key)}"
          end
        else
          th col.pretty_title, class: classes
        end
      end

      def build_table_body
        @tbody = tbody do
          # Build enough rows for our collection
          @collection.each do |elem|
            classes = [cycle('odd', 'even')]

            if @row_class
              classes << @row_class.call(elem)
            end

            tr(class: classes.flatten.join(' '), id: dom_id_for(elem))
          end
        end
      end

      def build_table_cell(col, item)
        td class: col.html_class do
          render_data col.data, item
        end
      end

      def render_data(data, item)
        value = if data.is_a? Proc
          data.call item
        elsif item.respond_to? data
          item.public_send data
        elsif item.respond_to? :[]
          item[data]
        end
        value = pretty_format(value) if data.is_a?(Symbol)
        value = status_tag value     if is_boolean? data, item
        value
      end

      def is_boolean?(data, item)
        if item.respond_to? :has_attribute?
          item.has_attribute?(data) &&
            item.column_for_attribute(data) &&
            item.column_for_attribute(data).type == :boolean
        end
      end

      # Returns an array for the current sort order
      #   current_sort[0] #=> sort_key
      #   current_sort[1] #=> asc | desc
      def current_sort
        @current_sort ||= begin
          order_clause = OrderClause.new params[:order]

          if order_clause.valid?
            [order_clause.field, order_clause.order]
          else
            []
          end
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
          i18n: @resource_class
        }
      end

      class Column

        attr_accessor :title, :data , :html_class

        def initialize(*args, &block) 
          @options = args.extract_options!

          @title = args[0]
          html_classes = [:col]
          if @options.has_key?(:class)
            html_classes << @options.delete(:class)
          elsif @title.present?
            html_classes << "col-#{@title.to_s.parameterize('_')}"
          end
          @html_class = html_classes.join(' ')
          @data = args[1] || args[0]
          @data = block if block
          @resource_class = args[2]
        end

        def sortable?
          if @options.has_key?(:sortable)
            !!@options[:sortable]
          elsif @resource_class
            @resource_class.column_names.include?(sort_column_name)
          else
            @title.present?
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
        #   column :username, sortable: 'other_column_to_sort_on'
        #
        # If you pass a block to be rendered for this column, the column
        # will not be sortable unless you pass a string to sortable to
        # sort the column on:
        #
        #   column('Username', sortable: 'login'){ @user.pretty_name }
        #   # => Sort key will be 'login'
        #
        def sort_key
          # If boolean or nil, use the default sort key.
          if @options[:sortable] == true || @options[:sortable] == false
            @data.to_s
          elsif @options[:sortable].nil?
            sort_column_name
          else
            @options[:sortable].to_s
          end
        end

        def pretty_title
          if @title.is_a? Symbol
            default = @title.to_s.titleize
            if @options[:i18n].respond_to? :human_attribute_name
              @title = @options[:i18n].human_attribute_name @title, default: default
            else
              default
            end
          else
            @title
          end
        end

        private

        def sort_column_name
          @data.is_a?(Symbol) ? @data.to_s : @title.to_s
        end
      end
    end
  end
end
