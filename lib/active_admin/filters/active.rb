# frozen_string_literal: true
require_relative "active_filter"

module ActiveAdmin
  module Filters
    class Active
      attr_reader :filters, :resource, :scopes

      # Instantiate a `Active` object containing collection of current active filters

      # @param resource [ActiveAdmin::Resource] current resource
      # @param search [Ransack::Search] search object
      #
      # @see ActiveAdmin::ResourceController::DataAccess#apply_filtering
      def initialize(resource, search)
        @resource = resource
        @filters = build_filters(search.conditions)
        @scopes = search.instance_variable_get(:@scope_args)
      end

      def all_blank?
        filters.blank? && scopes.blank?
      end

      private

      def build_filters(conditions)
        conditions.map { |condition| ActiveFilter.new(resource, condition.dup) }
      end
    end
  end
end
