module ActiveAdmin
  class ResourceController < BaseController
    module Form
      extend ActiveSupport::Concern

      included do
        helper_method :form_config
      end

      module ClassMethods

        def form_config=(config)
          @form_config = config
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

      protected

      def form_config
        @form_config ||= self.class.form_config
      end

    end
  end
end
