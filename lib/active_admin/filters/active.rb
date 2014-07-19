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
        ransack = Ransack::Search.new(@resource_class, @params)
        @params[:q].map do |param|
          {
            description: ransack.base.translate(param[0]),
            value: param[1]
          }
        end
      end

      def humanize_scope
        scope = @params[:scope]
        scope ? scope.humanize : "All"
      end
    end

  end
end
