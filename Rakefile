require 'bundler/gem_tasks'

require_relative "tasks/application_generator"

desc 'Creates a test rails app for the specs to run against'
task :setup, [:parallel, :rails_env, :template] do |_t, opts|
  ActiveAdmin::ApplicationGenerator.new(opts).generate
end

# Import all our rake tasks
FileList['tasks/**/*.rake'].each { |task| import task }

task default: :test

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort 'Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine'
  end
end

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end
