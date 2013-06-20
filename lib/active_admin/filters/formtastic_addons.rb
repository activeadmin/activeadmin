module ActiveAdmin
  module Filters
    module FormtasticAddons

      #
      # The below are Formtastic overrides to inspect Ransack's search object
      #

      # Returns the default label for a given attribute. Uses ActiveModel I18n if available.
      def humanized_method_name
        if klass.respond_to?(:human_attribute_name)
          klass.human_attribute_name(method)
        else
          method.to_s.send(builder.label_str_method)
        end
      end

      # Returns the association reflection for the method if it exists
      def reflection_for(method)
        klass.reflect_on_association(method) if klass.respond_to? :reflect_on_association
      end

      # Returns the column for an attribute on the object being searched if it exists.
      def column_for(method)
        klass.columns_hash[method.to_s] if klass.respond_to? :columns_hash
      end

      # An override to the built-in method, that respects Ransack.
      # Since this is corrected, `column?` will also work.
      def column
        column_for method
      end

      #
      # The below are custom methods that Formtastic does not provide.
      #

      # The resource class, unwrapped from Ransack
      def klass
        @object.object.klass
      end

      def polymorphic_foreign_type?(method)
        klass.reflections.values.select{ |r| r.macro == :belongs_to && r.options[:polymorphic] }
          .map(&:foreign_type).include? method.to_s
      end

    end
  end
end
