module ActiveAdmin
  module Inputs
    class FilterStringInput < ::Formtastic::Inputs::StringInput
      include FilterBase
      include FilterBase::SearchMethodSelect

      filter :contains, :equals, :starts_with, :ends_with

      # If the filter method includes a search condition, build a normal string search field.
      # Else, build a search field with a companion dropdown to choose a search condition from.
      def to_html
        if seems_searchable?
          input_wrapping do
            label_html <<
            builder.text_field(method, input_html_options)
          end
        else
          super # SearchMethodSelect#to_html
        input_wrapping do
          label_html <<
          builder.text_field(input_name, input_html_options)
        end
      end

      def label_text
        translation_per_search_field(super)
      end

      def input_name
        method.to_s.match(metasearch_conditions) ? method : "#{method}_contains"
      end

      def metasearch_conditions
        /starts_with|ends_with/
      end
    end
  end
end
