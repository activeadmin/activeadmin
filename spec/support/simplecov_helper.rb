# frozen_string_literal: true

module ActiveAdmin
  module TestSupport
    module SimpleCovHelper
      module_function

      def start(command_name = nil)
        return unless ENV["COVERAGE"] == "true"
        return if @started

        require "simplecov"

        ::SimpleCov.command_name(command_name) if command_name
        ::SimpleCov.start "activeadmin"

        @started = true
      end
    end
  end
end
