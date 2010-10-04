module ActiveAdmin
  class ResourceController < ::InheritedViews::Base
    module Form
      extend ActiveSupport::Concern

      included do
        helper_method :form_config
      end

      module ClassMethods
        def form(options = {}, &block)
          options[:block] = block
          @form_config = options
        end

        def form_config
          @form_config ||= default_form_config
        end

        def reset_form_config!
          @form_config = nil
        end

        def default_form_config
          config = {}
          config[:block] = lambda do |f|
            f.inputs
            f.buttons
          end
          config
        end
      end

      module InstanceMethods
        def form_config
          @form_config ||= self.class.form_config
        end
      end

    end
  end
end
