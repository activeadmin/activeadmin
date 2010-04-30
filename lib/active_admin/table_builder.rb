module ActiveAdmin
  class TableBuilder < IndexBuilder
    
    autoload :Column, 'active_admin/table_builder/column'
    
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
        
  end
end
