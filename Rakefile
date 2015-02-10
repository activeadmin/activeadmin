require 'bundler'
require 'rake'
Bundler.setup
Bundler::GemHelper.install_tasks

def cmd(command)
  puts command
  fail unless system command
end

require File.expand_path('../spec/support/detect_rails_version', __FILE__)

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
