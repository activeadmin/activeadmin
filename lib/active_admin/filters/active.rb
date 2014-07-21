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
        @params[:q].map do |param|
          {
            description: build_description(param),
            value: humanize_value(param)
          }
        end
      end

      def humanize_scope
        scope = @params['scope']
        scope ? scope.humanize : "All"
      end

      def build_description(param)
        ransack = Ransack::Search.new(@resource_class, @params)
        ransack.base.translate(param[0])
      end

      def humanize_value(param)
        association = @resource_class.ransackable_associations.detect { |r| param[0].include?(r) }

        if association
          association_class = association_class_for(association)
          association_class.find_by_id(param[1]).display_name
        else
          param[1]
        end
      end

      def association_class_for(association)
        @resource_class.reflect_on_association(association.to_sym).class_name.constantize
      end
    end

  end
end
