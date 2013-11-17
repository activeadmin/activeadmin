module ActiveAdmin
  module Inputs
    class FilterCheckBoxesInput < ::Formtastic::Inputs::CheckBoxesInput
      include FilterBase

      def input_name
        "#{object_name}[#{searchable_method_name}_in][]"
      end

      def selected_values
        @object.send("#{searchable_method_name}_in") || []
      end

      def searchable_method_name
        # Deal with has_many :through relationships in filters
        # If the relationship is a HMT, we set the search logic to be something
        # like :#{through_association}_#{end_association_id}.
        if searchable_through_association?
          [reflection.through_reflection.name, reflection.foreign_key].join('_')
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
