# frozen_string_literal: true

SimpleCov.configure do
  skip "tmp/development_apps/"
  skip "tmp/test_apps/"
  skip "tasks/test_application.rb"

  if ENV["COVERAGE"] == "true"
    require "simplecov-cobertura"
    formatter SimpleCov::Formatter::CoberturaFormatter
  end
end
