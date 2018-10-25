require 'parallel'
require_relative "application_generator"

desc "Run the full suite using parallel_tests to run on multiple cores"
task parallel_tests: [:setup_parallel_tests, 'parallel:spec', 'parallel:cucumber', 'cucumber:reloading']

desc "Creates a test rails app for the parallel specs to run against"
task :setup_parallel_tests do
  ActiveAdmin::ApplicationGenerator.new.generate
end

namespace :parallel do

  desc "Run the specs in parallel"
  task :spec do
    system "parallel_rspec --serialize-stdout --verbose spec/"
  end

  namespace :spec do

    %w(unit request).each do |type|
      desc "Run the #{type} specs in parallel"
      task type do
        system "parallel_rspec --serialize-stdout --verbose spec/#{type}"
      end
    end

  end

  desc "Run the cucumber scenarios in parallel"
  task :cucumber do
    system "parallel_cucumber --serialize-stdout --verbose features/"
  end

end
