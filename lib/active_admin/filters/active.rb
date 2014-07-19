module ActiveAdmin
  module Filters

    class Active
      attr_accessor :filters, :scope

      def initialize(resource_class, params)
        @resource_class, @params = resource_class, params
        @scope = humanize_scope
        @filters = translate_filters
      end

      private

      def translate_filters
        ransack = Ransack::Search.new(@resource_class, @params)
        @params[:q].map { |param| translate_single_filter(ransack, param) }
      end

      def translate_single_filter(ransack, param)
        "#{ransack.base.translate(param[0])} #{param[1]}"
      end

      def humanize_scope
        scope = @params[:scope]
        scope ? scope.humanize : "All"
      end
    end

  end
end
