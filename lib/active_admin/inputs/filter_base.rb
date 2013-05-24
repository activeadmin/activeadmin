module ActiveAdmin
  module Inputs
    module FilterBase
      include ::Formtastic::Inputs::Base
      include ::ActiveAdmin::Filters::FormtasticAddons

      extend ::ActiveSupport::Autoload
      autoload :SearchMethodSelect

      def input_wrapping(&block)
        template.content_tag :div, template.capture(&block), wrapper_html_options
      end

      def required?
        false
      end

      def wrapper_html_options
        { :class => "filter_form_field #{as}" }
      end

      # Override the standard finder to accept a proc
      def collection_from_options
        if options[:collection].is_a?(Proc)
          template.instance_eval(&options[:collection])
        else
          super
        end
      end

    end
  end
end
