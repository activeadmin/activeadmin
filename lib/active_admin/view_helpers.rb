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
        
        # Setup some nice variables for the block
        controller.send :set_resource_ivar, row_object && @resource = row_object && instance_variable_set("@#{resource_instance_name}", row_object)
        
        table_config.columns.each do |column|
          row_content = column.data.is_a?(Proc) ? instance_eval(&column.data) : row_object.send(column.data)
          table << "<td>#{row_content}</td>"
        end
        table << "</tr>"
      end
      
      table << "</table>"
      table
    end
    
  end
end