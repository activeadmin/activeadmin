desc "Creates a test rails app for the specs to run against"
task :setup do
  require 'rails/version'
  system("mkdir spec/rails") unless File.exists?("spec/rails")
  system "bundle exec rails new spec/rails/rails-#{Rails::VERSION::STRING} -m spec/support/rails_template.rb"
end

namespace :test do
  desc "Run against the important versions of rails"
  task :major_rails_versions do
    current_version = detect_rails_version if File.exists?("Gemfile.lock")
    ["3.0.10", "3.1.0"].each do |version|
      puts
      puts
      puts "== Using Rails #{version}"
      cmd "./script/use_rails #{version}"
      cmd "bundle exec rspec spec/unit"
      cmd "bundle exec rspec spec/integration"
      cmd "bundle exec cucumber features"
    end
    cmd "./script/use_rails #{current_version}" if current_version
  end

end

# Run specs and cukes
task :test do
  cmd "bundle exec rspec spec/unit"
  cmd "bundle exec rspec spec/integration"
  cmd "bundle exec cucumber features"
end

namespace :spec do
  desc "Run specs for all versions of rails"
  task :all do
    (0..6).to_a.each do |v|
      puts "Running for Rails 3.0.#{v}"
      cmd "rm Gemfile.lock" if File.exists?("Gemfile.lock")
      cmd "/usr/bin/env RAILS=3.0.#{v} bundle install"
      cmd "/usr/bin/env RAILS=3.0.#{v} rake spec"
    end
  end
end

require 'cucumber/rake/task'

namespace :cucumber do
  Cucumber::Rake::Task.new(:all) do |t|
    t.profile = 'default'
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.profile = 'wip'
  end
end

task :cucumber => "cucumber:all"
