desc "Creates a test rails app for the specs to run against"
task :setup do
  require 'rails/version'
  system("mkdir spec/rails") unless File.exists?("spec/rails")
  system "bundle exec rails new spec/rails/rails-#{Rails::VERSION::STRING} -m spec/support/rails_template.rb"
end

# Run specs and cukes
desc "Run the full suite"
task :test => ['spec:unit', 'spec:integration', 'cucumber']

namespace :test do

  desc "Run the full suite against the important versions of rails"
  task :major_supported_rails do
    current_version = detect_rails_version if File.exists?("Gemfile.lock")

    ["3.0.10", "3.1.0"].each do |version|
      puts
      puts "== Using Rails #{version}"

      if File.exists?("Gemfile.lock")
        puts "Removing the current Gemfile.lock"
        cmd "rm Gemfile.lock"
      end

      cmd "export RAILS=#{version} && ./script/use_rails #{version}"
      cmd "export RAILS=#{version} && bundle exec rspec spec/unit"
      cmd "export RAILS=#{version} && bundle exec rspec spec/integration"
      cmd "export RAILS=#{version} && bundle exec cucumber features"
    end
    cmd "./script/use_rails #{current_version}" if current_version
  end

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

end
