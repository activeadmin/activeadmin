module ActiveAdmin
  module ViewHelpers
    
    def render_index_from_config(index_config)
      send index_config.display_method, index_config
    end

    def breadcrumb(separator = "&rsaquo;")
      html_safe_or_string @breadcrumbs.map { |txt, path| link_to_unless((path.blank? || current_page?(path)), h(txt), path) }.join(" #{separator} ")
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

    def sortable_header_for(text, sort_key)
      # Setup Sortable CSS Classes - .sortable, .sorted-asc, .sorted-desc
      classes = ["sortable"]
      if current_sort[0] == sort_key
        classes << "sorted-#{current_sort[1]}"
      end

      th = "<th class=\"#{classes.join(' ')}\">"
      th << link_to(text, request.query_parameters.merge(:order => "#{sort_key}_#{order_for_sort_key(sort_key)}").except(:page))
      th << "</th>"
    end
    
    def active_admin_table(table_config)
      table = "<table id=\"#{resource_class.name.underscore.pluralize}_index_table\" class=\"index_table\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
      
      columns = table_config.columns.select do |column|
        instance_eval &column.conditional_block
      end

      # Header
      table << "<thead>"
      table << "<tr>"
      columns.each do |column|
        if column.sortable?
          table << sortable_header_for(column.title, column.sort_key)
        else
          table << "<th>#{column.title}</th>"
        end
      end
      table << "</tr>"
      table << "</thead>"
      
      # Body
      table << "<tbody>"
      collection.each do |row_object|
        table << "<tr class=\"#{cycle 'odd', 'even'}\">"
        
        # Setup some nice variables for the block
        controller.send :set_resource_ivar, row_object && @resource = row_object && instance_variable_set("@#{resource_instance_name}", row_object)
        
        columns.each do |column|
          row_content = column.data.is_a?(Proc) ? instance_eval(&column.data) : row_object.send(column.data)
          table << "<td>#{row_content}</td>"
        end
        table << "</tr>"
      end
      table << "</tbody>"
      
      table << "</table>"
      html_safe_or_string(table)
    end
    
    def html_safe_or_string(string)
      string.respond_to?(:html_safe) ? string.html_safe : string
    end

    def title(_title)
      @page_title = _title 
    end

    def status_tag(status, options = {})
      options[:class] ||= ""
      options[:class] << ["status", status.downcase].join(' ')
      content_tag :span, status, options
    end

    def active_admin_form_for(*args, &block)
    end

    def active_admin_filters_form_for(search, filters, options = {})
      options[:builder] ||= ActiveAdmin::FilterFormBuilder
      options[:url] ||= collection_path
      options[:html] ||= {}
      options[:html][:method] = :get
      options[:as] = :q
      form_for search, options do |f|
        filters.each do |filter_options|
          attribute = filter_options.delete(:attribute)
          f.filter attribute, filter_options
        end
        f.submit("Filter") + hidden_field_tag("order", params[:order])
      end
    end

  end
end
