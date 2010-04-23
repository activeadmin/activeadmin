module ActiveAdmin
  module ViewHelpers
    
    def active_admin_table(table_config)
      table = "<table id=\"#{resource_class.name.underscore.pluralize}_index_table\" class=\"index_table\">"
      
      # Header
      table << "<tr>"
      table_config.columns.each do |column|
        table << "<th>#{column.title}</th>"
      end
      table << "</tr>"
      
      # Body
      collection.each do |row_object|
        table << "<tr class=\"#{cycle 'odd', 'even'}\">"
        
        table_config.columns.each do |column|
          extend_proc_with_view_helpers(column.data) if column.data.is_a?(Proc)
          row_content = column.data.is_a?(Proc) ? column.data.call(row_object) : row_object.send(column.data)
          table << "<td>#{row_content}</td>"
        end
        table << "</tr>"
      end
      
      table << "</table>"
      table
    end
    
    # Extends a blocks context with helper methods so that
    # it feels like the block is being executed in the view
    def extend_proc_with_view_helpers(proc)
      code_to_evel = <<-EOF
        extend ActionController::PolymorphicRoutes
        extend #{controller.class.name}.master_helper_module
        extend ActionView::Helpers
      EOF
      eval code_to_evel, proc.binding
    end
    
  end
end