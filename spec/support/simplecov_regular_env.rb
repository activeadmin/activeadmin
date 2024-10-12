# frozen_string_literal: true
if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.command_name "tests#{ENV["TEST_ENV_NUMBER"]}"
end
