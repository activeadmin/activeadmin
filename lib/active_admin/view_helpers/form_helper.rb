module ActiveAdmin
  module ViewHelpers
    module FormHelper
      
      def active_admin_form_for(resource, options = {}, &block)
        options = Marshal.load( Marshal.dump(options) )
        options[:builder] ||= ActiveAdmin::FormBuilder
        semantic_form_for resource, options, &block
      end

    end
  end
end
