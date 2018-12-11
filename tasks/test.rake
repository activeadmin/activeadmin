require_relative "application_generator"

desc "Run the full suite using parallel_tests to run on multiple cores"
task test: [:setup, :spec, :cucumber]

desc "Create a test rails app for the parallel specs to run against"
task :setup, [:rails_env, :template] do |_t, opts|
  ActiveAdmin::ApplicationGenerator.new(opts).generate
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
    sh("rspec --require #{File.dirname(__dir__)}/spec/support/simplecov_changes_env.rb --tag changes_filesystem")
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
    sh("cucumber --profile filesystem-changes")
  end

  desc "Run the cucumber scenarios that test reloading"
  task :reloading do
    sh("cucumber --profile class-reloading")
  end
end
