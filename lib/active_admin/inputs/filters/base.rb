module ActiveAdmin
  module Inputs
    module Filters
      module Base
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

        # Can pass proc to filter label option
        def label_from_options
          res = super
          res = res.call if res.is_a? Proc
          res
        end

        def wrapper_html_options
          opts = super
          (opts[:class] ||= '') << " filter_form_field filter_#{as}"
          opts
        end

        # Override the standard finder to accept a proc
        def collection_from_options
          if options[:collection].is_a?(Proc)
            template.instance_exec(&options[:collection])
          else
            super
          end
        end

      end
    end
  end
end
