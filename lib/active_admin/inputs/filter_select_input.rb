module ActiveAdmin
  module Inputs
    class FilterSelectInput < ::Formtastic::Inputs::SelectInput
      include FilterBase

      def input_name
        "#{super}_eq"
      end

      def input_options
        super.merge(:include_blank => I18n.t('active_admin.any'))
      end

      def method
        if super.to_s.scan(/_id/).count('_id') == 1
          super.to_s.sub(/_id$/, '').to_sym
        else
          super.to_s.to_sym
        end
      end

      def extra_input_html_options
        {}
      end
    end
  end
end
