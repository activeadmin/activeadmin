module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      def display_name_method_for(resource)
        @@display_name_methods_cache ||= {}
        @@display_name_methods_cache[resource.class] ||= 
          active_admin_application.display_name_methods.find{|method| resource.respond_to? method }
      end

      # Tries to display an object with as friendly of output
      # as possible.
      def display_name(resource)
        resource.send(display_name_method_for(resource))
      end

      # Return a pretty string for any object
      # Date Time are formatted via #localize with :format => :long
      # ActiveRecord objects are formatted via #auto_link
      # We attempt to #display_name of any other objects
      def pretty_format(object)
        case object
        when String
          object
        when Arbre::Element
          object
        when Date, Time
          localize(object, :format => :long)
        when ActiveRecord::Base
          auto_link(object)
        else
          display_name(object)
        end
      end

    end
  end
end
