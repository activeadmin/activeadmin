# frozen_string_literal: true
SimpleCov.start do
  command_name "tests#{ENV["TEST_ENV_NUMBER"]}"
  add_filter %r{^/spec/}
  add_filter "tmp/development_apps/"
  add_filter "tmp/test_apps/"
  add_filter "tasks/test_application.rb"
end

if ENV["COVERAGE"] == "true"
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
