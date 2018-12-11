if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.command_name ["regular specs", ENV['TEST_ENV_NUMBER']].join(" ").rstrip
end
