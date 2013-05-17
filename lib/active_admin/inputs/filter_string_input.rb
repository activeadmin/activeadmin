module ActiveAdmin
  module Inputs
    class FilterStringInput < ::Formtastic::Inputs::StringInput
      include FilterBase

      def to_html
        if method.to_s.match(metasearch_conditions)
          input_wrapping do
            label_html <<
            builder.text_field(input_name_simple, input_html_options)
          end
        else
          input_wrapping do
            [ label_html,
              select_html,
              " ",
              input_html
            ].join("\n").html_safe
          end
        end
      end

      def input_name_simple
        method.to_s.match(metasearch_conditions) ? method : "#{method}_contains"
      end

      def metasearch_conditions
        /contains|starts_with|ends_with/
      end

      def label_text
        I18n.t('active_admin.search_field', :field => super)
      end

      def input_html
        builder.text_field current_filter, input_html_options_multiple
      end

      def input_html_options_multiple
        { :size => 10, :id => "q_#{method}" }
      end

      def select_html
        template.select_tag '', select_options, select_html_options
      end

      def select_options
        template.options_for_select filters, current_filter
      end

      def select_html_options
        { :onchange => "document.getElementById('q_#{method}').name = 'q[' + this.value + ']';" }
      end

      # Returns the filter currently in use, or the first one available
      def current_filter
        ( filters.detect{ |(_,query)| @object.send query } || filters.first )[1]
      end

      def filters
        (options[:filters] || default_filters).collect do |(translation,scope)|
          [translation, "#{method}_#{scope}"]
        end
      end

      def default_filters
        [ [I18n.t('active_admin.contains'),    'contains'],
          [I18n.t('active_admin.starts_with'), 'starts_with'],
          [I18n.t('active_admin.ends_with'),   'ends_with'] ]
      end

    end
  end
end
