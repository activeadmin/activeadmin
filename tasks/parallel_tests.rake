require 'parallel'
require_relative "application_generator"

desc "Run the full suite using parallel_tests to run on multiple cores"
task parallel_tests: ['parallel:setup_parallel_tests', 'parallel:spec', 'parallel:cucumber', 'cucumber:class_reloading']

namespace :parallel do

  desc "Setup parallel_tests DBs"
  task :setup_parallel_tests do
    ActiveAdmin::ApplicationGenerator.new(parallel: true).generate
  end

  desc "Run the specs in parallel"
  task spec: :setup_parallel_tests do
    system "parallel_rspec spec/"
  end

  namespace :spec do

    %w(unit request).each do |type|
      desc "Run the #{type} specs in parallel"
      task type => :setup_parallel_tests do
        system "parallel_rspec spec/#{type}"
      end
    end

  end

  desc "Run the cucumber scenarios in parallel"
  task cucumber: :setup_parallel_tests do
    system "parallel_cucumber features/"
  end

end
