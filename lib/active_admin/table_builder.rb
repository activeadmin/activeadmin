module ActiveAdmin
  class TableBuilder < IndexBuilder
    
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
    
    def display_method
      :active_admin_table
    end

    # Adds links to View, Edit and Delete
    def default_actions(options = {})
      options = {
        :name => ""
      }.merge(options)
      column options[:name] do 
        links = link_to "View", resource_path(resource)
        links += " | "
        links += link_to "Edit", edit_resource_path(resource)
        links += " | "
        links += link_to "Delete", resource_path(resource), :method => :destroy, :confirm => "Are you sure you want to delete this?"
        links
      end
    end

    class Renderer < ActiveAdmin::Renderer
      def to_html(builder, collection, resource_instance_name = nil)
        @builder, @collection = builder, collection
        wrap_with_pagination(collection, :entry_name => resource_name) do
          table_options = {
            :id => resource_name.underscore.pluralize, 
            :class => "index_table", 
            :border => 0, 
            :cellpadding => 0, 
            :cellspacing => 0            
          }
          content_tag :table, table_options do
            table_head + table_body
          end          
        end
      end

      def columns
        @columns ||= @builder.columns.select do |column|
          instance_eval &column.conditional_block
        end
      end

      def table_head
        content_tag :thead do
          columns.collect do |column|
            if column.sortable?
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

      def resource_instance_name
        @resource_instance_name ||= @collection.first.class.name.underscore
      end

      def table_cell(column, item)
        # Setup some nice variables for the block
        @resource = item && instance_variable_set("@#{resource_instance_name}", item)
        row_content = case column.data
                      when Proc
                        instance_eval(&column.data)
                      when Symbol, String
                        item.send(column.data.to_sym)
                      else
                        ""
                      end
        content_tag :td, row_content.to_s.html_safe
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
          :if => lambda{ true }
        }
      end
      
    end
        
  end
end
