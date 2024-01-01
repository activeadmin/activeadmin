# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      DISPLAY_NAME_FALLBACK = -> {
        klass = self.class
        name = if klass.respond_to?(:model_name)
                 if klass.respond_to?(:primary_key)
                   "#{klass.model_name.human} ##{send(klass.primary_key)}"
                 else
                   klass.model_name.human
                 end
               elsif klass.respond_to?(:primary_key)
                 " ##{send(klass.primary_key)}"
               end
        name.present? ? name : to_s
      }

      def DISPLAY_NAME_FALLBACK.inspect
        "DISPLAY_NAME_FALLBACK"
      end

      # Attempts to call any known display name methods on the resource.
      # See the setting in `application.rb` for the list of methods and their priority.
      def display_name(resource)
        unless resource.nil?
          result = render_in_context(resource, display_name_method_for(resource))
          if result.to_s&.strip&.present?
            ERB::Util.html_escape(result)
          else
            ERB::Util.html_escape(render_in_context(resource, DISPLAY_NAME_FALLBACK))
          end
        end
      end

      # Looks up and caches the first available display name method.
      # To prevent conflicts, we exclude any methods that happen to be associations.
      # If no methods are available and we're about to use the Kernel's `to_s`, provide our own.
      def display_name_method_for(resource)
        @@display_name_methods_cache ||= {}
        @@display_name_methods_cache[resource.class] ||= begin
          methods = active_admin_application.display_name_methods - association_methods_for(resource)
          method = methods.detect { |method| resource.respond_to? method }

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

      def format_attribute(resource, attr)
        value = find_value resource, attr

        if value.is_a?(Arbre::Element)
          value
        elsif boolean_attr?(resource, attr, value)
          Arbre::Context.new { status_tag value }
        else
          pretty_format value
        end
      end

      def find_value(resource, attr)
        if attr.is_a? Proc
          attr.call resource
        elsif resource.respond_to? attr
          resource.public_send attr
        elsif resource.respond_to? :[]
          resource[attr]
        end
      end

      # Attempts to create a human-readable string for any object
      def pretty_format(object)
        case object
        when String, Numeric, Symbol, Arbre::Element
          object.to_s
        when Date, Time
          I18n.localize object, format: active_admin_application.localize_format
        when Array
          format_collection(object)
        else
          if defined?(::ActiveRecord) && object.is_a?(ActiveRecord::Base) ||
             defined?(::Mongoid) && object.class.include?(Mongoid::Document)
            auto_link object
          elsif defined?(::ActiveRecord) && object.is_a?(ActiveRecord::Relation)
            format_collection(object)
          else
            display_name object
          end
        end
      end

      def format_collection(collection)
        safe_join(collection.map { |item| pretty_format(item) }, ", ")
      end

      def boolean_attr?(resource, attr, value)
        case value
        when TrueClass, FalseClass
          true
        else
          if resource.class.respond_to? :columns_hash
            column = resource.class.columns_hash[attr.to_s] and column.type == :boolean
          end
        end
      end

    end
  end
end
