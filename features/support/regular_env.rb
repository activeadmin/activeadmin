if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.command_name ["regular features", ENV['TEST_ENV_NUMBER']].join(" ").rstrip
end

require_relative 'env'
