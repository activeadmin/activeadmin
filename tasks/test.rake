desc "Run the full suite using 1 core"
task test: ['spec:unit', 'spec:request', 'cucumber', 'cucumber:class_reloading']

desc "Run the full suite against all supported Rails versions using 1 core"
task :test_all do
  Dir.glob("gemfiles/rails_*.gemfile").each do |gemfile|
    print "\n=== Running tests using #{gemfile} ===\n\n"

    Bundler.with_clean_env do
      system({ "BUNDLE_GEMFILE" => gemfile }, "bundle exec rake test")
    end
  end
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do

  desc "Run the unit specs"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  desc "Run the request specs"
  RSpec::Core::RakeTask.new(:request) do |t|
    t.pattern = "spec/requests/**/*_spec.rb"
  end

end

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.profile = 'default'
  t.bundler = false
end

namespace :cucumber do

  Cucumber::Rake::Task.new(:wip, "Run the cucumber scenarios with the @wip tag") do |t|
    t.profile = 'wip'
    t.bundler = false
  end

  Cucumber::Rake::Task.new(:class_reloading, "Run the cucumber scenarios that test reloading") do |t|
    t.profile = 'class-reloading'
    t.bundler = false
  end

end
