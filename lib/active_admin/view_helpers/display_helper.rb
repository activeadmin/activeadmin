module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      DISPLAY_NAME_FALLBACK = ->{
        name, klass = "", self.class
        name << klass.model_name.human         if klass.respond_to? :model_name
        name << " ##{send(klass.primary_key)}" if klass.respond_to? :primary_key
        name.present? ? name : to_s
      }
      def DISPLAY_NAME_FALLBACK.inspect
        'DISPLAY_NAME_FALLBACK'
      end

      # Attempts to call any known display name methods on the resource.
      # See the setting in `application.rb` for the list of methods and their priority.
      def display_name(resource)
        render_in_context resource, display_name_method_for(resource) if resource
      end

      # Looks up and caches the first available display name method.
      # To prevent conflicts, we exclude any methods that happen to be associations.
      # If no methods are available and we're about to use the Kernel's `to_s`, provide our own.
      def display_name_method_for(resource)
        @@display_name_methods_cache ||= {}
        @@display_name_methods_cache[resource.class] ||= begin
          methods = active_admin_application.display_name_methods - association_methods_for(resource)
          method  = methods.detect{ |method| resource.respond_to? method }

          if method != :to_s || resource.method(method).source_location
            method
          else
            DISPLAY_NAME_FALLBACK
          end
        end
      end

      def association_methods_for(resource)
        return [] unless resource.class.respond_to? :reflect_on_all_associations
        resource.class.reflect_on_all_associations.map(&:name)
      end

      # Return a pretty string for any object
      # Date Time are formatted via #localize with format: :long
      # ActiveRecord and Mongoid objects are formatted via #auto_link
      # We attempt to #display_name of any other objects
      def pretty_format(object)
        case object
        when String, Numeric, Arbre::Element
          object.to_s
        when Date, Time
          localize(object, format: :long)
        when ->(obj){defined?(::ActiveRecord) && obj.is_a?(ActiveRecord::Base)}
          auto_link(object)
        when ->(obj){defined?(::Mongoid) && obj.class.included_modules.include?(Mongoid::Document)}
          auto_link(object)
        else
          display_name(object)
        end
      end

    end
  end
end
