require 'bundler/gem_tasks'
require "chandler/tasks"

# Import all our rake tasks
FileList['tasks/**/*.rake'].each { |task| import task }

#
# Add chandler as a prerequisite for `rake release`
#
task "release:rubygem_push" => "chandler:push"

task default: :test

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end
