module ActiveAdmin
  module Inputs
    class FilterBooleanInput < ::Formtastic::Inputs::SelectInput
      include FilterBase

      def input_name
        return method if seems_searchable?

        "#{method}_eq"
      end

      # was "#{object_name}[#{association_primary_key}]"
      def input_html_options_name
        "#{object_name}[#{input_name}]"
      end

      # Provide the AA translation to the blank input field.
      def include_blank
        I18n.t 'active_admin.any' if super
      end
    end
  end
end
