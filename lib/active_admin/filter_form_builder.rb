module ActiveAdmin
  # This form builder defines methods to build filter forms such
  # as the one found in the sidebar of the index page of a standard resource.
  class FilterFormBuilder < FormBuilder

    def filter(method, options = {})
      return "" if method.nil? || method == ""
      options[:as] ||= default_input_type(method)
      return "" unless options[:as]
      content = input(method, options)
      form_buffers.last << content.html_safe if content
    end

    protected

    # Returns the default filter type for a given attribute
    def default_input_type(method, options = {})
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

    def custom_input_class_name(as)
      "ActiveAdmin::Inputs::Filter#{as.to_s.camelize}Input"
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
