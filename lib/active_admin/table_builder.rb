module ActiveAdmin
  class TableBuilder
    
    attr_reader :columns
    
    def initialize
      @columns = []
      yield self if block_given?
    end
    
    def column(*args, &block)
      @columns << Column.new(*args, &block)
    end

    # This method allows you to add many columns at
    # once or returns the list of all columns.
    # 
    # TableBuilder.new do |t|
    #   t.columns :first, :second, :third
    # end
    # 
    # OR
    #
    # builder.columns #=> [:first, :second, :third]
    def columns(first_column = nil, *more)
      return @columns unless first_column 
      [first_column, more].flatten.each do |c|
        column(c)
      end
    end

    # Helper method to quickly render a table builder
    def to_html(view, collection, options)
      Renderer.new(view).to_html(self, collection, options)
    end

    class Renderer < ActiveAdmin::Renderer
      def to_html(builder, collection, options = {})
        @builder, @collection = builder, collection
        @sortable = options.delete(:sortable) || false
        table_options = {
          :border => 0, 
          :cellpadding => 0, 
          :cellspacing => 0            
        }.merge(options)
        content_tag :table, table_options do
          table_head + table_body
        end
      end

      def columns
        @columns ||= @builder.columns.select do |column|
          instance_eval &column.conditional_block
        end
      end

      def sortable?
        @sortable
      end

      def table_head
        content_tag :thead do
          columns.collect do |column|
            if sortable? && column.sortable?
              sortable_header_for column.title, column.sort_key
            else
              content_tag :th, column.title
            end
          end.join
        end
      end

      def table_body
        content_tag :tbody do
          @collection.collect{|item| table_row(item) }.join
        end
      end

      def table_row(item)
        content_tag :tr, :class => cycle('odd', 'even') do
          columns.collect{|column| table_cell(column, item) }.join
        end
      end

      def resource
        @resource
      end

      def table_cell(column, item)
        row_content = call_method_or_proc_on(item, column.data) || ""
        l(row_content) if [Date, DateTime, Time].include?(row_content)
        content_tag :td, row_content
      end

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

      def conditional_block
        @options[:if]
      end
      
      private
      
      def pretty_title(raw)
        raw.is_a?(Symbol) ? raw.to_s.split('_').collect{|s| s.capitalize }.join(' ') : raw
      end

      def default_options
        {
          :sortable => true,
          :if => proc{ true }
        }
      end
      
    end
        
  end
end
