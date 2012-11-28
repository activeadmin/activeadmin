require 'spork'

module ActiveAdmin
  module Spec
    module FakeApp
      # Initialize Rails app in a clean environment.
      # @param tests [Proc] which have to be run after app was initialized
      # @return [Array, Object] single result if one test was passed given,
      #   otherwise returns an array of results
      def self.run(*tests)
        forker = Spork::Forker.new do
          require 'active_admin'
          require 'action_controller/railtie'

          app = Class.new(Rails::Application)
          app.config.active_support.deprecation = :log

          yield(app.config) if block_given?
          app.initialize!

          results = tests.map &:call
          results.size == 1 ? results.first : results
        end
        forker.result
      end
    end
  end
end
