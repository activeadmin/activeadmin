module ActiveAdmin
  module Inputs
    class FilterStringInput < ::Formtastic::Inputs::StringInput
      include FilterBase
      include FilterBase::SearchMethodSelect

      def to_html
        if search_conditions =~ method.to_s
          input_wrapping do
            label_html <<
            builder.text_field(input_name_simple, input_html_options)
          end
        else
          super
        end
      end

      def input_name_simple
        method.to_s.match(search_conditions) ? method : "#{method}_contains"
      end

      def search_conditions
        /_(contains|starts_with|ends_with)\z/
      end

      def label_text
        I18n.t('active_admin.search_field', :field => super)
      end

      def default_filters
        [ [I18n.t('active_admin.contains'),    'contains'],
          [I18n.t('active_admin.starts_with'), 'starts_with'],
          [I18n.t('active_admin.ends_with'),   'ends_with'] ]
      end

    end
  end
end
