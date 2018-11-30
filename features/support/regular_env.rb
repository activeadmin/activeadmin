if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.command_name ["regular features", ENV['TEST_ENV_NUMBER']].compact.join(" ")
end

require_relative 'env'
