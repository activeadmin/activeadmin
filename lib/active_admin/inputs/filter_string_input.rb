module ActiveAdmin
  module Inputs
    class FilterStringInput < ::Formtastic::Inputs::StringInput
      include FilterBase

      def to_html
        input_wrapping do
          label_html <<
          builder.text_field(input_name, input_html_options)
        end
      end

      def label_text
        I18n.t('active_admin.search_field', :field => super)
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
