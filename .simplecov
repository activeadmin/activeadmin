# frozen_string_literal: true
SimpleCov.start do
  add_filter %r{^/spec/}
  add_filter "tmp/development_apps/"
  add_filter "tmp/test_apps/"
end

if ENV["COVERAGE"] == "true"
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
