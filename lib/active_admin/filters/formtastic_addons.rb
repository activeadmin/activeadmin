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
          method.to_s.public_send(builder.label_str_method)
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
        klass.reflect_on_all_associations.select{ |r| r.macro == :belongs_to && r.options[:polymorphic] }
          .map(&:foreign_type).include? method.to_s
      end

      #
      # These help figure out whether the given method or association will be recognized by Ransack.
      #

      def searchable_has_many_through?
        if reflection && reflection.options[:through]
          reflection.through_reflection.klass.ransackable_attributes.include? reflection.foreign_key
        else
          false
        end
      end

      def seems_searchable?
        has_predicate? || scope?
      end

      # If the given method has a predicate (like _eq or _lteq), it's pretty
      # likely we're dealing with a valid search method.
      def has_predicate?
        !!Ransack::Predicate.detect_from_string(method.to_s)
      end

      # Ransack lets you define custom search methods, called ransackers.
      def ransacker?
        klass._ransackers.key? method.to_s
      end

      # Ransack supports exposing selected scopes on your model for advanced searches.
      def scope?
        context = Ransack::Context.for klass
        context.respond_to?(:ransackable_scope?) && context.ransackable_scope?(method.to_s, klass)
      end

    end
  end
end
