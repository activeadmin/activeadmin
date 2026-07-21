# frozen_string_literal: true

SimpleCov.profiles.define "activeadmin" do
  # Opt out of SimpleCov 1.0's default test_frameworks profile to reintroduce
  # `/features` coverage and surface dead code there.
  remove_filter %r{\A(test|features|spec|autotest)/}
  skip %r{\Aspec/}
  skip "tmp/development_apps/"
  skip "tmp/test_apps/"
  skip "tasks/test_application.rb"

  if ENV["COVERAGE"] == "true"
    require "simplecov-cobertura"
    formatter SimpleCov::Formatter::CoberturaFormatter
  end
end
