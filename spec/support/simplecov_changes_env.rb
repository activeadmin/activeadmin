if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.command_name "filesystem changes specs"
end
