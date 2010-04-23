module ActiveAdmin
  class TableBuilder
    
    autoload :Column, 'active_admin/table_builder/column'
    
    attr_reader :columns
    
    def initialize
      @columns = []
      yield self if block_given?
    end
    
    def column(*args, &block)
      @columns << Column.new(*args, &block)
    end
        
  end
end