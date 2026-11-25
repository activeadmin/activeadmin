# frozen_string_literal: true
desc "Run the full suite using parallel_tests to run on multiple cores"
task test: [:setup, :spec]

desc "Prepare the Rails app for the specs"
task setup: :"setup:create"

namespace :setup do
  desc "Rebuild the Rails app for the specs"
  task :force, [:rails_env, :template] do |_task, opts|
    require_relative "test_application"
    ActiveAdmin::TestApplication.new(opts).soft_generate(force: true)
  end

  desc "Prepare the Rails app for the specs"
  task :create, [:rails_env, :template] do |_task, opts|
    require_relative "test_application"
    ActiveAdmin::TestApplication.new(opts).soft_generate
  end
end

desc "Run all specs in parallel"
task :spec do
  sh("bin/parallel_rspec")
end
