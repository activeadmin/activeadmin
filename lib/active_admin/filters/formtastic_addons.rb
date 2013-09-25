module ActiveAdmin
  module Filters
    module FormtasticAddons

      #
      # The below are Formtastic method overrides that jump inside of the Ransack
      # search object to get at the object being searched upon.
      #

      def humanized_method_name
        if klass.respond_to?(:human_attribute_name)
          klass.human_attribute_name(method)
        else
          method.to_s.send(builder.label_str_method)
        end
      end

      def reflection_for(method)
        klass.reflect_on_association(method) if klass.respond_to? :reflect_on_association
      end

      def column_for(method)
        klass.columns_hash[method.to_s] if klass.respond_to? :columns_hash
      end

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

      #
      # These help figure out whether the given method will be recognized by Ransack.
      #

      def seems_searchable?
        has_predicate? || ransacker?
      end

      # If the given method has a predicate (like _eq or _lteq), it's pretty
      # likely we're dealing with a valid search method.
      def has_predicate?
        !!Ransack::Predicate.detect_and_strip_from_string!(method.to_s)
      end

      # Ransack lets you define custom search methods, so we need to check for them.
      def ransacker?
        klass._ransackers.key? method.to_s
      end

    end
  end
end
