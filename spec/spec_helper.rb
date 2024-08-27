# frozen_string_literal: true
require "simplecov" if ENV["COVERAGE"] == "true"

require_relative "support/matchers/perform_database_query_matcher"
require_relative "support/shared_contexts/capture_stderr"
require_relative "support/active_support_deprecation"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.filter_run focus: true
  config.filter_run_excluding changes_filesystem: true
  config.run_all_when_everything_filtered = true
  config.color = true
  config.order = :random
  config.example_status_persistence_file_path = ".rspec_failures"
end
