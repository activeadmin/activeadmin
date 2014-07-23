module ActiveAdmin
  module Filters

    class Active
      attr_accessor :filters, :scope

      def initialize(resource_class, params)
        @resource_class, @params = resource_class, params
        @scope = humanize_scope
        @filters = build_filters
      end

      private

      def build_filters
        @params[:q].map { |param| Humanized.new(@resource_class, param) }
      end

      def humanize_scope
        scope = @params['scope']
        scope ? scope.humanize : "All"
      end
    end

    class Humanized
      include ActiveAdmin::ViewHelpers

      def initialize(klass, param)
        @klass = klass
        @body = param[0]
        @value = param[1]
      end

      def attribute_name
        raw_description.split(description_predicate).first
      end

      def description
        description_predicate ? description_predicate.humanize.downcase : raw_description
      end

      def value
        if association?
          resource = association_class.find(@value)
          display_name(resource)
        else
          @value
        end
      end

      private

      def association?
        @klass.ransackable_associations.any? { |assoc| association_name == assoc }
      end

      def association_name
        attribute_name.strip.downcase.pluralize
      end

      def association_class
        @klass.reflect_on_association(association_name.to_sym).klass
      end

      def description_predicate
        ransack_predicates.detect { |predicate| raw_description.include?(predicate) }
      end

      # Will return something like "Name starts_with Bob"
      def raw_description
        @raw_description ||= Ransack::Translate.attribute(@body, context: @klass.search.context)
      end

      # Reverse order by length
      def ransack_predicates
        Ransack.predicates.keys.sort_by { |predicate| -predicate.length }
      end
    end

  end
end
