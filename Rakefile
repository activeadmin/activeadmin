# frozen_string_literal: true
require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

import "tasks/local.rake"
import "tasks/test.rake"
import "tasks/dependencies.rake"

gemfile = ENV["BUNDLE_GEMFILE"]

if gemfile.nil? || File.expand_path(gemfile) == File.expand_path("Gemfile")
  import "tasks/release.rake"
end

task default: :test

task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end
