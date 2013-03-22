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

      def check_box_html
        template.check_box_tag("#{object_name}[#{method}]", checked_value, checked?, input_html_options)
      end

      def search_method
        method.to_s.match(metasearch_conditions) ? method : "#{method}_eq"
      end

      def checked?
        if defined? ActionView::Helpers::InstanceTag
          object && ActionView::Helpers::InstanceTag.check_box_checked?(object.send(search_method), checked_value)
        else
          object && boolean_checked?(object.send(search_method), checked_value)
        end
      end

      def input_html_options
        { :name => "q[#{search_method}]" }
      end

      def metasearch_conditions
        /(is_true|is_false|is_present|is_blank|is_null|is_not_null)$/
      end

    end
  end
end
