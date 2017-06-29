require 'active_admin/filters/active_filter'

module ActiveAdmin
  module Filters

    class Active
      attr_accessor :filters, :resource

      # Instantiate a `Active` object containing collection of current active filters

      # @param resource [ActiveAdmin::Resource] current resource
      # @param search [Ransack::Search] search object
      #
      # @see ActiveAdmin::ResourceController::DataAcces#apply_filtering
      def initialize(resource, search)
        @resource = resource
        @filters = build_filters(search.conditions)
      end

      private

      def build_filters(conditions)
        conditions.map { |condition| ActiveFilter.new(resource, condition.dup) }
      end

    end

  end
end
