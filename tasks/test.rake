desc "Run the full suite using parallel_tests to run on multiple cores"
task test: [:setup, :spec, :cucumber]

desc "Create a test rails app for the parallel specs to run against if it doesn't exist already"
task setup: :"setup:create"

namespace :setup do
  desc "Forcefully create a test rails app for the parallel specs to run against"
  task :force, [:rails_env, :template] => [:require, :rm, :run]

  desc "Create a test rails app for the parallel specs to run against if it doesn't exist already"
  task :create, [:rails_env, :template] => [:require, :run]

  desc "Makes test app creation code available"
  task :require do
    if ENV["COVERAGE"] == "true"
      require "simplecov"

      SimpleCov.command_name "test app creation"
    end

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

task spec: :"spec:all"

namespace :spec do
  desc "Run all specs"
  task all: [:regular, :filesystem_changes]

  desc "Run the standard specs in parallel"
  task :regular do
    sh("bin/parallel_rspec spec/")
  end

  desc "Run the specs that change the filesystem sequentially"
  task :filesystem_changes do
    sh({ "RSPEC_FILESYSTEM_CHANGES" => "true" }, "bin/rspec")
  end
end

desc "Run the cucumber scenarios in parallel"
task cucumber: :"cucumber:all"

namespace :cucumber do
  desc "Run all cucumber suites"
  task all: [:regular, :filesystem_changes, :reloading]

  desc "Run the standard cucumber scenarios in parallel"
  task :regular do
    sh("bin/parallel_cucumber features/")
  end

  desc "Run the cucumber scenarios that change the filesystem sequentially"
  task :filesystem_changes do
    sh("bin/cucumber --profile filesystem-changes")
  end

  desc "Run the cucumber scenarios that test reloading"
  task :reloading do
    sh("bin/cucumber --profile class-reloading")
  end
end
