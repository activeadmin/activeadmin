module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      def display_name_method_for(resource)
        @@display_name_methods_cache ||= {}
        @@display_name_methods_cache[resource.class] ||= 
          ActiveAdmin.display_name_methods.find{|method| resource.respond_to? method }
      end

      # Tries to display an object with as friendly of output
      # as possible.
      def display_name(resource)
        resource.send(display_name_method_for(resource))
      end

    end
  end
end
