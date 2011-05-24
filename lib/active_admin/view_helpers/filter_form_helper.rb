module ActiveAdmin

  module ViewHelpers
    module FilterFormHelper

      # Helper method to render a filter form
      def active_admin_filters_form_for(search, filters, options = {})
        options[:builder] ||= ActiveAdmin::FilterFormBuilder
        options[:url] ||= collection_path
        options[:html] ||= {}
        options[:html][:method] = :get
        options[:as] = :q
        clear_link = link_to("Clear Filters", "#", :class => "clear_filters_btn")
        form_for search, options do |f|
          filters.each do |filter_options|
            filter_options = filter_options.dup
            attribute = filter_options.delete(:attribute)
            f.filter attribute, filter_options
          end

          buttons = content_tag :div, :class => "buttons" do
            f.submit("Filter") + 
              clear_link + 
              hidden_field_tag("order", params[:order]) +
              hidden_field_tag("scope", params[:scope])
          end

          f.form_buffers.last + buttons
        end
      end

    end
  end

  # This form builder defines methods to build filter forms such
  # as the one found in the sidebar of the index page of a standard resource.
  class FilterFormBuilder < FormBuilder
  
    def filter(method, options = {})
      return "" if method.nil? || method == ""
      options[:as] ||= default_filter_type(method)
      return "" unless options[:as]
      field_type = options.delete(:as)
      content = with_new_form_buffer do
        send("filter_#{field_type}_input", method, options)
      end
      @form_buffers.last << template.content_tag(:div, content, :class => "filter_form_field filter_#{field_type}")
    end

    protected

    def filter_string_input(method, options = {})
      field_name = "#{method}_contains"

      [ label(field_name, "Search #{method.to_s.titlecase}"),
        text_field(field_name)
      ].join("\n").html_safe
    end

    def filter_date_range_input(method, options = {})
      gt_field_name = "#{method}_gte"
      lt_field_name = "#{method}_lte"

      [ label(gt_field_name, method.to_s.titlecase),
        filter_date_text_field(gt_field_name),
        " - ",
        filter_date_text_field(lt_field_name)
      ].join("\n").html_safe
    end

    def filter_date_text_field(method)
      current_value = @object.send(method)
      text_field(method, :size => 12, :class => "datepicker", :max => 10, :value => current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : "")
    end

    def filter_numeric_input(method, options = {})
      filters = numeric_filters_for_method(method, options.delete(:filters) || default_numeric_filters)
      current_filter = current_numeric_scope(filters)
      filter_select = @template.select_tag '', @template.options_for_select(filters, current_filter), 
                                  :onchange => "document.getElementById('#{method}_numeric').name = 'q[' + this.value + ']';"
      filter_input = text_field current_filter, :size => 10, :id => "#{method}_numeric"

      [ label(method),
        filter_select,
        " ",
        filter_input
      ].join("\n").html_safe
    end
    
    def numeric_filters_for_method(method, filters)
      filters.collect{|scope| [scope[0], [method,scope[1]].join("_") ] }
    end

    # Returns the scope for which we are currently searching. If no search is available
    # it returns the first scope
    def current_numeric_scope(filters)
      filters[1..-1].inject(filters.first){|a,b| object.send(b[1].to_sym) ? b : a }[1]
    end

    def default_numeric_filters
      [['Equal To', 'eq'], ['Greater Than', 'gt'], ['Less Than', 'lt']]
    end

    def filter_select_input(method, options = {})
      association_name = method.to_s.gsub(/_id$/, '').to_sym
      input_name = (generate_association_input_name(method).to_s + "_eq").to_sym
      collection = find_collection_for_column(association_name, options)

      [ label(input_name, method.to_s.titlecase),
        select(input_name, collection, options.merge(:include_blank => 'Any'))
      ].join("\n").html_safe
    end

    def filter_check_boxes_input(method, options = {})
      input_name = (generate_association_input_name(method).to_s + "_in").to_sym
      collection = find_collection_for_column(method, options)
      selected_values = @object.send(input_name) || []
      checkboxes = template.content_tag :div, :class => "check_boxes_wrapper" do
        collection.map do |c|
          label = c.is_a?(Array) ? c.first : c
          value = c.is_a?(Array) ? c.last : c
          "<label><input type=\"checkbox\" name=\"q[#{input_name}][]\" value=\"#{value}\" #{selected_values.include?(value) ? "checked" : ""}/> #{label}</label>"
        end.join("\n").html_safe
      end

      [ label(input_name, method.to_s.titlecase),
        checkboxes
      ].join("\n").html_safe
    end

    # Override the standard finder to accept a proc
    def find_collection_for_column(method, options = {})
      options = options.dup
      case options[:collection]
      when Proc
        options[:collection] = options[:collection].call
      end
      super(method, options)
    end

    # Returns the default filter type for a given attribute
    def default_filter_type(method)
      if column = column_for(method)
        case column.type
        when :date, :datetime
          return :date_range
        when :string, :text
          return :string
        when :integer
          return :select if reflection_for(method.to_s.gsub('_id','').to_sym)
          return :numeric
        when :float, :decimal
          return :numeric
        end
      end

      if reflection = reflection_for(method)
        return :select if reflection.macro == :belongs_to && !reflection.options[:polymorphic]
      end
    end

    # Returns the column for an attribute on the object being searched
    # if it exists. Otherwise returns nil
    def column_for(method)
      @object.base.columns_hash[method.to_s] if @object.base.respond_to?(:columns_hash)
    end

    # Returns the association reflection for the method if it exists
    def reflection_for(method)
      @object.base.reflect_on_association(method) if @object.base.respond_to?(:reflect_on_association)
    end

  end    
end
