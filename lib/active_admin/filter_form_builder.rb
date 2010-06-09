module ActiveAdmin
  class FilterFormBuilder < FormBuilder
  
    def filter(method, options = {})
      return "" if method.nil? || method == ""
      options[:as] ||= default_filter_type(method)
      content = skip_form_buffers do
        send("filter_#{options.delete(:as)}_input", method, options)
      end
      @form_buffers.last << template.content_tag(:div, content, :class => "filter-form-field")
    end


    protected

    def filter_string_input(method, options = {})
      field_name = "#{method}_contains"
      l = label(field_name, "Search #{method.to_s.titlecase}")
      f = text_field(field_name)
      l + f
    end

    def filter_date_range_input(method, options = {})
      gt_field_name = "#{method}_gte"
      lt_field_name = "#{method}_lte"
      l = label(gt_field_name, method.to_s.titlecase)
      gt = filter_date_text_field(gt_field_name)
      lt = filter_date_text_field(lt_field_name)
      l + gt + " - " + lt
    end

    def filter_date_text_field(method)
      current_value = @object.send(method)
      text_field(method, :size => 10, :max => 10, :value => current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : "")
    end

    # Returns the default filter type for a given attribute
    def default_filter_type(method)
      if column = column_for(method)
        case column.type
        when :date, :datetime
          return :date_range
        else
          return :string
        end
      else
        return :string
      end
    end

    # Returns the column for an attribute on the object being searched
    # if it exists. Otherwise returns nil
    def column_for(method)
      @object.base.columns_hash[method.to_s] if @object.base.respond_to?(:columns_hash)
    end

  end
end
