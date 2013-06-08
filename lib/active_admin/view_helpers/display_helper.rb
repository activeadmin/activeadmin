module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      # Attempts to call any known display name methods on the resource.
      # See the setting in `application.rb` for the list of methods and their priority.
      def display_name(resource)
        resource.send display_name_method_for resource if resource
      end

      # Looks up and caches the first available display name method.
      def display_name_method_for(resource)
        @@display_name_methods_cache ||= {}
        @@display_name_methods_cache[resource.class] ||= begin
          methods = active_admin_application.display_name_methods - association_methods_for(resource)
          methods.detect{ |method| resource.respond_to? method }
        end
      end

      # To prevent conflicts, we exclude any methods that happen to be associations.
      def association_methods_for(resource)
        return [] unless resource.class.respond_to? :reflect_on_all_associations
        resource.class.reflect_on_all_associations.map(&:name)
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
