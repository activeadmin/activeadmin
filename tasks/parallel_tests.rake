require 'parallel'
require 'shellwords'
require_relative "application_generator"

desc "Run the full suite using parallel_tests to run on multiple cores"
task parallel_tests: ['parallel:setup_parallel_tests', 'parallel:spec', 'parallel:features', 'cucumber:class_reloading']

namespace :parallel do

  def rails_app_rake(task)
    require 'rails/version'
    system "cd spec/rails/rails-#{Rails::VERSION::STRING}; rake #{task}"
  end

  task :after_setup_hook do
    rails_app_rake "parallel:load_schema"
    rails_app_rake "parallel:create_cucumber_db"
    rails_app_rake "parallel:load_schema_cucumber_db"
  end

  desc "Setup parallel_tests DBs"
  task :setup_parallel_tests do
    ActiveAdmin::ApplicationGenerator.new(parallel: true).generate
  end

  def run_in_parallel(command)
    bash("ENV['TEST_ENV_NUMBER']=#{Parallel.processor_count} #{command}")
  end

  def bash(command)
    escaped_command = Shellwords.escape(command)
    system("bash -c #{escaped_command}")
  end

  desc "Run the specs in parallel"
  task spec: :setup_parallel_tests do
    run_in_parallel "parallel_rspec spec/"
  end

  namespace :spec do

    %w(unit request).each do |type|
      desc "Run the #{type} specs in parallel"
      task type => :setup_parallel_tests do
        run_in_parallel "parallel_rspec spec/#{type}"
      end
    end

  end

  desc "Run the cucumber features in parallel"
  task features: :setup_parallel_tests do
    run_in_parallel "parallel_cucumber features/"
  end

end
