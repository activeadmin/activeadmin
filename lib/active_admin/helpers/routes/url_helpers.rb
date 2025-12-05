# frozen_string_literal: true
module ActiveAdmin
  module Helpers
    module Routes
      # Proxy module that wraps Rails route helpers with custom url_for behavior.
      # This fixes route generation for custom namespaces in isolated engines.
      #
      # The issue: When ActiveAdmin uses `isolate_namespace`, route helpers like
      # `admin_posts_path` internally call `url_for` with a hash like
      # {:controller => "admin/posts", :action => "index"}. In isolated engines,
      # this can fail to find the route because url_for looks in the engine's
      # routes instead of the main app's routes.
      #
      # The fix: Override `url_for` to always use the main app's router for
      # hash-based options, ensuring custom namespaces work correctly.
      module UrlHelpers
        # First, include the Rails route helpers - this gives us all the
        # named route methods like admin_posts_path, etc.
        include Rails.application.routes.url_helpers

        delegate :app_routes, to: Routes
        alias_method :_routes, :app_routes

        delegate :default_url_options, :optimize_routes_generation?, to: :app_routes

        # Then override url_for - this will be found FIRST in method lookup
        # because it's defined directly on this module, after the include.
        # When route helpers call url_for internally, they'll use this version.
        def url_for(options = nil)
          case options
          when nil
            super
          when Hash
            # For hash options, always route through the main app's router
            # This ensures custom namespaces work in isolated engines
            options = options.dup
            options[:only_path] = true unless options.key?(:only_path) || options.key?(:host)
            app_routes.url_for(options)
          when ActionController::Parameters
            unless options.permitted?
              raise ArgumentError, "Generating a URL from unpermitted parameters is not allowed"
            end
            route_options = options.to_h.symbolize_keys
            route_options[:only_path] = true unless route_options.key?(:only_path) || route_options.key?(:host)
            app_routes.url_for(route_options)
          when String
            options
          when Symbol
            send(options)
          when Array
            opts = options.extract_options!
            opts[:only_path] = true unless opts.key?(:only_path) || opts.key?(:host)
            polymorphic_url(options, opts)
          when Class
            polymorphic_url(options, only_path: true)
          else
            # For ActiveRecord models or other objects
            polymorphic_url(options, only_path: true)
          end
        end

        def url_options
          default_url_options || {}
        end
      end

      # Extend self with UrlHelpers so we can call Routes.admin_posts_path directly
      extend UrlHelpers

      def self.app_routes
        Rails.application.routes
      end

      def self.default_url_options
        Rails.application.routes.default_url_options || {}
      end
    end
  end
end
