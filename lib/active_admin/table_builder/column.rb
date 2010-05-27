module ActiveAdmin
  class TableBuilder
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
        raw.is_a?(Symbol) ? raw.to_s.split('_').collect{|s| s.capitalize }.join(' ') : raw
      end

      def default_options
        {
          :sortable => true
        }
      end
      
    end
  end
end
