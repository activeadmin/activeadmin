# frozen_string_literal: true
if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.command_name "reload features"
end

require_relative "env"
