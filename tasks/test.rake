desc "Creates a test rails app for the specs to run against"
task :setup, :parallel do |t, args|
  require 'rails/version'
  fuzzy_rails_version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}.x"
  # The files created vary depending on version of Ruby (e.g. JRuby uses different database adapters)
  if File.exists?(dir = "spec/rails/ruby-#{RUBY_VERSION}-rails-#{fuzzy_rails_version}")
    puts "test app #{dir} already exists; skipping"
  else
    cmd("mkdir spec/rails") unless File.exists?("spec/rails")
    cmd "#{'INSTALL_PARALLEL=yes' if args[:parallel]} BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec rails new #{dir} -m spec/support/rails_template.rb --skip-bundle"
    Rake::Task['parallel:after_setup_hook'].invoke if args[:parallel]
  end
end

desc "Run the full suite using 1 core"
task test: ['spec:unit', 'spec:request', 'cucumber', 'cucumber:class_reloading']

unless ENV["NOCOVER"]
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task test_with_coveralls: [:test, 'coveralls:push']
end

namespace :test do

  def run_tests_against(*versions)
    versions.each do |fuzzy_rails_version|
      puts
      puts "== Using Rails #{fuzzy_rails_version}"
      cmd "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec rspec spec"
      cmd "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec cucumber features"
      cmd "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec cucumber -p class-reloading features"
    end
  end

  desc "Run the full suite against the important versions of rails"
  task :major_supported_rails do
    run_tests_against *%(3.2.x 4.1.x 4.2.x)
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

  desc "Run the request specs"
  RSpec::Core::RakeTask.new(:request) do |t|
    t.pattern = "spec/requests/**/*_spec.rb"
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
