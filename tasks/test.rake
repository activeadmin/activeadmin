require_relative "test_application"

desc "Run the full suite using parallel_tests to run on multiple cores"
task test: [:setup, :spec, :cucumber]

desc "Create a test rails app for the parallel specs to run against"
task :setup, [:rails_env, :template] do |_t, opts|
  ActiveAdmin::TestApplication.new(opts).generate
end

task spec: :"spec:all"

namespace :spec do
  desc "Run all specs"
  task all: [:regular, :filesystem_changes, :reloading]

  desc "Run the standard specs in parallel"
  task :regular do
    sh("bin/parallel_rspec spec/")
  end

  desc "Run the specs that change the filesystem sequentially"
  task :filesystem_changes do
    sh({ "RSPEC_FILESYSTEM_CHANGES" => "true" }, "bin/rspec")
  end

  desc "Run the specs that require reloading"
  task :reloading do
    sh({ "CLASS_RELOADING" => "true" }, "bin/rspec")
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
