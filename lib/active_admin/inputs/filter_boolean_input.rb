module ActiveAdmin
  module Inputs
    class FilterBooleanInput < ::Formtastic::Inputs::BooleanInput
      include FilterBase

      def to_html
        input_wrapping do
          [ label_html,
            check_box_html
          ].join("\n").html_safe
        end
      end

      def label_text
        super.sub(/_eq\z/, '') + '?'
      end

      def method
        super.to_s =~ search_conditions ? super : "#{super}_eq"
      end

      def search_conditions
        /(is_true|is_false|is_present|is_blank|is_null|is_not_null)\z/
      end

    end
  end
end
