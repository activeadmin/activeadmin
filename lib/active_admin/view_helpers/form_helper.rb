module ActiveAdmin
  module ViewHelpers
    module FormHelper
      
      def active_admin_form_for(resource, options = {}, &block)
        options[:builder] ||= ActiveAdmin::FormBuilder
        semantic_form_for resource, options, &block
      end

    end
  end
end
