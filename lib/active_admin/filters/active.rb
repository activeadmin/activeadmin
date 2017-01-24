require 'active_admin/filters/humanized'

module ActiveAdmin
  module Filters

    class Active
      attr_accessor :filters, :scope

      def initialize(resource_class, params)
        @resource_class = resource_class
        @params = normalize_params(params)
        @scope = humanize_scope
        @filters = build_filters
      end

      private

      def normalize_params(params)
        if params.is_a?(HashWithIndifferentAccess)
          params
        else
          params.to_unsafe_h
        end
      end

      def build_filters
        filters = @params[:q] || []
        filters.map{ |param| Humanized.new(param) }
      end

      def humanize_scope
        scope = @params['scope']
        scope ? scope.humanize : "All"
      end
    end

  end
end
