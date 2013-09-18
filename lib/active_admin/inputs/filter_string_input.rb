module ActiveAdmin
  module Inputs
    class FilterStringInput < ::Formtastic::Inputs::StringInput
      include FilterBase
      include FilterBase::SearchMethodSelect

      filter :contains, :equals, :starts_with, :ends_with

      # If the filter method includes a search condition, build a normal string search field.
      # Else, build a search field with a companion dropdown to choose a search condition from.
      def to_html
        if method.to_s =~ /_(#{filters.join('|')})\z/
          input_wrapping do
            label_html <<
            builder.text_field(method, input_html_options)
          end
        else
          super # SearchMethodSelect#to_html
        end
      end

    end
  end
end
