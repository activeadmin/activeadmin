module ActiveAdmin
  module Filters

    def self.included(base)
      base.extend ClassMethods
      base.send :helper_method, :filters_config
    end

    module ClassMethods
      def filter(attribute, options = {})
        return false if attribute.nil?
        @filters ||= []
        @filters << options.merge(:attribute => attribute)
      end

      def filters_config
        @filters && @filters.any? ? @filters : default_filters_config
      end

      def reset_filters!
        @filters = []
      end

      def default_filters_config
        resource_class.columns.collect{|c| { :attribute => c.name.to_sym } }
      end      
    end


    def filters_config
      self.class.filters_config
    end


    class FormBuilder < FormBuilder
    
      def filter(method, options = {})
        return "" if method.nil? || method == ""
        options[:as] ||= default_filter_type(method)
        return "" unless options[:as]
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
        text_field(method, :size => 12, :class => "datepicker", :max => 10, :value => current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : "")
      end

      def filter_numeric_input(method, options = {})
        l = label(method)
        filters = numeric_filters_for_method(method, options.delete(:filters) || default_numeric_filters)
        current_filter = current_numeric_scope(filters)
        s = @template.select_tag '', @template.options_for_select(filters, current_filter), 
                                    :onchange => "document.getElementById('#{method}_numeric').name = 'q[' + this.value + ']';"
        f = text_field current_filter, :size => 10, :id => "#{method}_numeric"
        l + s + " " + f
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
        input_name = (generate_association_input_name(method).to_s + "_eq").to_sym
        l = label(input_name, method.to_s.titlecase)
        collection = find_collection_for_column(method, options)
        f = select(input_name, collection, options.merge(:include_blank => 'Any'))
        l + f
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
            return :numeric
          end
        end

        if reflection = reflection_for(method)
          return :select if reflection.macro == :belongs_to
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
end
