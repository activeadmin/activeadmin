module ActiveAdmin
  module Filters

    class ActiveFilter
      include ActiveAdmin::ViewHelpers

      attr_reader :resource, :condition, :related_class

      # Instantiate a `ActiveFilter`
      #
      # @param resource [ActiveAdmin::Resource] current resource
      # @param condition [Ransack::Nodes::Condition] applied ransack condition
      def initialize(resource, condition)
        @resource = resource
        @condition = condition
        @related_class = find_class
      end

      def values
        condition_values = condition.values.map(&:value)
        if related_class
          related_class.find(condition_values)
        else
          condition_values
        end
      end

      def label
        # TODO: to remind us to go back to the simpler str.downcase once we support ruby >= 2.4 only.
        translated_predicate = predicate_name.mb_chars.downcase.to_s
        if related_class
          "#{related_class.model_name.human} #{translated_predicate}".strip
        else
          "#{attribute_name} #{translated_predicate}".strip
        end
      end

      def predicate_name
        I18n.t("active_admin.filters.predicates.#{condition.predicate.name}",
               default: ransack_predicate_name)
      end

      def html_options
        { class: "current_filter current_filter_#{condition.key}" }
      end

      private

      def resource_class
        resource.resource_class
      end

      def attribute_name
        resource_class.human_attribute_name(name)
      end

      #@return Ransack::Nodes::Attribute
      def condition_attribute
        condition.attributes[0]
      end

      def name
        condition_attribute.attr_name
      end

      def ransack_predicate_name
        Ransack::Translate.predicate(condition.predicate.name)
      end

      # detect related class for Ransack::Nodes::Attribute
      def find_class
        if condition_attribute.klass != resource_class && condition_attribute.klass.primary_key == name.to_s
          condition_attribute.klass
        else
          assoc = condition_attribute.klass.reflect_on_all_associations.
            reject { |r| r.options[:polymorphic] }. #skip polymorphic
            detect { |r| r.foreign_key.to_s == name.to_s }
          assoc.class_name.constantize if assoc
        end
      end
    end
  end
end
