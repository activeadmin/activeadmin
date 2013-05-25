module ActiveAdmin
  module Inputs
    class FilterCheckBoxesInput < ::Formtastic::Inputs::CheckBoxesInput
      include FilterBase

      def input_name
        "#{object_name}[#{association_primary_key || method}_in][]"
      end

      def selected_values
        @object.send("#{association_primary_key || method}_in") || []
      end

      # Add whitespace before label
      def choice_label(choice)
        ' ' + super
      end

      # Don't wrap in UL tag
      def choices_group_wrapping(&block)
        template.capture(&block)
      end

      # Don't wrap in LI tag
      def choice_wrapping(html_options, &block)
        template.capture(&block)
      end

      # Don't render hidden fields
      def hidden_field_for_all
        ""
      end

      # Don't render hidden fields
      def hidden_fields?
        false
      end
    end
  end
end
