if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.command_name "reload features"
end

require_relative 'env'
