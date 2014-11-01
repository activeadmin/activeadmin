module ActiveAdmin
  module Inputs
    class FilterCheckBoxesInput < ::Formtastic::Inputs::CheckBoxesInput
      include FilterBase

      def input_name
        "#{object_name}[#{searchable_method_name}_in][]"
      end

      def selected_values
        @object.public_send("#{searchable_method_name}_in") || []
      end

      def searchable_method_name
        if searchable_has_many_through?
          "#{reflection.through_reflection.name}_#{reflection.foreign_key}"
        else
          association_primary_key || method
        end
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
