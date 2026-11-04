# frozen_string_literal: true
module ActiveAdmin
  module Helpers
    # Route helpers of the route set that holds ActiveAdmin's routes, which is
    # an engine's route set when ActiveAdmin.routes is called from one.
    module Routes
      # Not used by ActiveAdmin anymore; kept for apps that include it.
      module UrlHelpers
        include Rails.application.routes.url_helpers
      end

      def self.default_url_options
        route_set.default_url_options || {}
      end

      def self.route_set
        ActiveAdmin.application.route_set
      end

      def self.method_missing(name, ...)
        helpers = route_set.url_helpers
        helpers.respond_to?(name) ? helpers.public_send(name, ...) : super
      end

      def self.respond_to_missing?(name, include_private = false)
        route_set.url_helpers.respond_to?(name) || super
      end
    end
  end
end
