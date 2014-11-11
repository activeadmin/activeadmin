require 'active_admin/filters/humanized'

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
        @params[:q] ||= []
        @params[:q].map { |param| Humanized.new(param) }
      end

      def humanize_scope
        scope = @params['scope']
        scope ? scope.humanize : "All"
      end
    end

  end
end
