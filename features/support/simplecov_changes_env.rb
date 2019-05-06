if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.command_name "filesystem changes features"
end

require_relative 'env'
