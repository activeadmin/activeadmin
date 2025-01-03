# frozen_string_literal: true
module ActiveAdmin
  module Views
    class TableFor < Arbre::HTML::Table
      builder_method :table_for

      def tag_name
        "table"
      end

      def build(obj, *attrs)
        options = attrs.extract_options!
        @sortable = options.delete(:sortable)
        @collection = obj.respond_to?(:each) && !obj.is_a?(Hash) ? obj : [obj]
        @resource_class = options.delete(:i18n)
        @resource_class ||= @collection.klass if @collection.respond_to? :klass

        @columns = []
        @tbody_html = options.delete(:tbody_html)
        @row_html = options.delete(:row_html)
        # To be deprecated, please use row_html instead.
        @row_class = options.delete(:row_class)

        build_table
        super(options)
        add_class "data-table"
        columns(*attrs)
      end

      def columns(*attrs)
        attrs.each { |attr| column(attr) }
      end

      def column(*args, &block)
        options = default_options.merge(args.extract_options!)
        title = args[0]
        data = args[1] || args[0]

        col = Column.new(title, data, @resource_class, options, &block)
        @columns << col

        # Build our header item
        within @header_row do
          build_table_header(col)
        end

        # Add a table cell for each item
        @collection.each_with_index do |resource, index|
          within @tbody.children[index] do
            build_table_cell col, resource
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
        sort_key = sortable? && col.sortable? && col.sort_key
        params = request.query_parameters.except :page, :order, :commit, :format

        attributes = {
          class: col.html_class,
          "data-column": col.title_id.presence,
          "data-sortable": (sort_key.present?) ? "" : nil,
          "data-sort-direction": (sort_key && current_sort[0] == sort_key) ? current_sort[1] : nil
        }

        if sort_key
          th(attributes) do
            link_to params: params, order: "#{sort_key}_#{order_for_sort_key(sort_key)}" do
              svg = '<svg class="data-table-sorted-icon" fill="none" viewBox="0 0 10 6"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/></svg>'

              (col.pretty_title + svg).html_safe
            end
          end
        else
          th col.pretty_title, attributes
        end
      end

      def build_table_body
        @tbody = tbody(**(@tbody_html || {})) do
          # Build enough rows for our collection
          @collection.each do |elem|
            html_options = @row_html&.call(elem) || {}
            html_options.reverse_merge!(class: @row_class&.call(elem))
            tr(id: dom_id_for(elem), **html_options)
          end
        end
      end

      def build_table_cell(col, resource)
        td class: col.html_class, "data-column": col.title_id.presence do
          html = helpers.format_attribute(resource, col.data)
          # Don't add the same Arbre twice, while still allowing format_attribute to call status_tag
          current_arbre_element << html unless current_arbre_element.children.include? html
        end
      end

      # Returns an array for the current sort order
      #   current_sort[0] #=> sort_key
      #   current_sort[1] #=> asc | desc
      def current_sort
        @current_sort ||= begin
          order_clause = active_admin_config.order_clause.new(active_admin_config, params[:order])

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
        return "desc" unless current_key == sort_key
        current_order == "desc" ? "asc" : "desc"
      end

      def default_options
        {
          i18n: @resource_class
        }
      end

      class Column

        attr_accessor :title, :title_id, :data, :html_class

        def initialize(*args, &block)
          @options = args.extract_options!
          @title = args[0]
          @title_id = @title.to_s.parameterize(separator: "_") if @title.present? && !title.is_a?(Arbre::Element)
          @html_class = @options.delete(:class)
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
        def sort_key
          # If boolean or nil, use the default sort key.
          if @options[:sortable].nil? || @options[:sortable] == true || @options[:sortable] == false
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
