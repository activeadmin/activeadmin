desc "Creates a test rails app for the specs to run against"
task :setup, :parallel do |t, args|
  require 'rails/version'
  if File.exists? dir = "spec/rails/rails-#{Rails::VERSION::STRING}"
    puts "test app #{dir} already exists; skipping"
  else
    system("mkdir spec/rails") unless File.exists?("spec/rails")
    system "#{'INSTALL_PARALLEL=yes' if args[:parallel]} bundle exec rails new #{dir} -m spec/support/rails_template.rb --skip-bundle"
    Rake::Task['parallel:after_setup_hook'].invoke if args[:parallel]
  end
end

desc "Run the full suite using 1 core"
task test: ['spec:unit', 'spec:integration', 'cucumber', 'cucumber:class_reloading']

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task test_with_coveralls: [:test, 'coveralls:push']

namespace :test do

  def run_tests_against(*versions)
    current_version = detect_rails_version if File.exists?("Gemfile.lock")

    versions.each do |version|
      puts
      puts "== Using Rails #{version}"

      cmd "./script/use_rails #{version}"
      cmd "bundle exec rspec spec"
      cmd "bundle exec cucumber features"
      cmd "bundle exec cucumber -p class-reloading features"
    end

    cmd "./script/use_rails #{current_version}" if current_version
  end

  desc "Run the full suite against the important versions of rails"
  task :major_supported_rails do
    run_tests_against *TRAVIS_RAILS_VERSIONS
  end

  desc "Alias for major_supported_rails"
  task :all => :major_supported_rails

end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do

  desc "Run the unit specs"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  desc "Run the integration specs"
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = "spec/integration/**/*_spec.rb"
  end

end


require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.profile = 'default'
end

namespace :cucumber do

  Cucumber::Rake::Task.new(:wip, "Run the cucumber scenarios with the @wip tag") do |t|
    t.profile = 'wip'
  end

  Cucumber::Rake::Task.new(:class_reloading, "Run the cucumber scenarios that test reloading") do |t|
    t.profile = 'class-reloading'
  end

end
