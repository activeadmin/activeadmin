require 'active_admin/filters/humanized'

module ActiveAdmin
  module Filters

    class Active
      attr_accessor :filters

      def initialize(resource_class, params)
        @resource_class = resource_class
        @params = params.to_unsafe_h
        @filters = build_filters
      end

      private

      def build_filters
        filters = @params['q'] || []
        filters.map{ |param| Humanized.new(param) }
      end

    end

  end
end
