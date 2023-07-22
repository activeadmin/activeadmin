# frozen_string_literal: true

SimpleCov.start do
  load_profile "test_frameworks"

  add_filter "tmp/development_apps/"
  add_filter "tmp/test_apps/"

  add_group 'Libraries', 'lib/'
  add_group 'Tasks', 'tasks/'

  track_files "lib/**/*.rb" # TODO: track "tasks/**/*.rb"
end

if ENV["COVERAGE"] == "true"
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
