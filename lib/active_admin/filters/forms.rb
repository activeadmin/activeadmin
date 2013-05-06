module ActiveAdmin
  module Filters

    # This form builder defines methods to build filter forms such
    # as the one found in the sidebar of the index page of a standard resource.
    class FormBuilder < ::ActiveAdmin::FormBuilder

      def filter(method, options = {})
        method = method.to_s.sub(/_id\z/,'').to_sym

        if method.present? && options[:as] ||= default_input_type(method)
          form_buffers.last << input(method, options)
        else
          ''
        end
      end

      protected

      # Returns the default filter type for a given attribute
      def default_input_type(method, options = {})
        if reflection_for(method)
          :select
        elsif column = column_for(method)
          case column.type
          when :date, :datetime
            :date_range
          when :string, :text
            :string
          when :integer, :float, :decimal
            :numeric
          when :boolean
            :boolean
          end
        end
      end

      def custom_input_class_name(as)
        "Filter#{as.to_s.camelize}Input"
      end

      def active_admin_input_class_name(as)
        "ActiveAdmin::Inputs::Filter#{as.to_s.camelize}Input"
      end

      #
      # The below overrides force Formtastic to use `base` instead of `class`
      #

      # Returns the column for an attribute on the object being searched if it exists.
      def column_for(method)
        @object.base.columns_hash[method.to_s] if @object.base.respond_to?(:columns_hash)
      end

      # Returns the association reflection if it exists.
      def reflection_for(method)
        @object.base.reflect_on_association(method) if @object.base.respond_to?(:reflect_on_association)
      end

    end


    # This module is included into the view
    module ViewHelper

      # Helper method to render a filter form
      def active_admin_filters_form_for(search, filters, options = {})
        options[:builder] ||= ActiveAdmin::Filters::FormBuilder
        options[:url] ||= collection_path
        options[:html] ||= {}
        options[:html][:method] = :get
        options[:html][:class] ||= "filter_form"
        options[:as] = :q
        clear_link = link_to(I18n.t('active_admin.clear_filters'), "#", :class => "clear_filters_btn")
        form_for search, options do |f|
          filters.group_by{ |o| o[:attribute] }.each do |attribute, array|
            options      = array.last # grab last-defined `filter` call from DSL
            if_block     = options[:if]     || proc{ true }
            unless_block = options[:unless] || proc{ false }
            if call_method_or_proc_on(self, if_block) && !call_method_or_proc_on(self, unless_block)
              f.filter options[:attribute], options.except(:attribute, :if, :unless)
            end
          end

          buttons = content_tag :div, :class => "buttons" do
            f.submit(I18n.t('active_admin.filter')) +
              clear_link +
              hidden_field_tags_for(params, :except => [:q, :page])
          end

          f.form_buffers.last + buttons
        end
      end

    end

  end
end
