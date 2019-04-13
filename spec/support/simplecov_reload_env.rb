if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.command_name "reload specs"
end
