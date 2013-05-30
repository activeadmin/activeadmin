require 'rubygems'
require 'bundler/setup'

require 'rake'

require 'appraisal'

def cmd(command)
  puts command
  raise unless system command
end

# Import all our rake tasks
FileList['tasks/**/*.rake'].each { |task| import task }

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
