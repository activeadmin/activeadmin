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
        super.to_s.gsub('_id','').to_sym
      end

      def extra_input_html_options
        {}
      end
    end
  end
end
