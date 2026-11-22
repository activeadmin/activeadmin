# frozen_string_literal: true
desc "Run the full suite using parallel_tests to run on multiple cores"
task test: [:setup, :spec]

desc "Create a test rails app for the parallel specs to run against if it doesn't exist already"
task setup: :"setup:create"

namespace :setup do
  desc "Forcefully create a test rails app for the parallel specs to run against"
  task :force, [:rails_env, :template] => [:require, :rm, :run]

  desc "Create a test rails app for the parallel specs to run against if it doesn't exist already"
  task :create, [:rails_env, :template] => [:require, :run]

  desc "Makes test app creation code available"
  task :require do
    require_relative "test_application"
  end

  desc "Create a test rails app for the parallel specs to run against"
  task :run, [:rails_env, :template] do |_t, opts|
    ActiveAdmin::TestApplication.new(opts).soft_generate
  end

  task :rm, [:rails_env, :template] do |_t, opts|
    test_app = ActiveAdmin::TestApplication.new(opts)

    FileUtils.rm_rf test_app.app_dir
  end
end

desc "Run all specs in parallel"
task :spec do
  sh("bin/parallel_rspec")
end
