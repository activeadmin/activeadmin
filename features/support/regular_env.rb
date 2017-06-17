if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.command_name "regular features"
end

require_relative 'env'
