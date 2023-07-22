# frozen_string_literal: true
require "bundler/gem_tasks"

import "tasks/local.rake"
import "tasks/test.rake"

gemfile = ENV["BUNDLE_GEMFILE"]

if gemfile.nil? || File.expand_path(gemfile) == File.expand_path("Gemfile")
  import "tasks/changelog.rake"
  import "tasks/docs.rake"
  import "tasks/release.rake"
end

task default: :test

task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end
