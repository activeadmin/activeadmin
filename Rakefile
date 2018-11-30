require 'bundler/gem_tasks'
require "chandler/tasks"

import 'tasks/docs.rake'
import 'tasks/gemfiles.rake'
import 'tasks/lint.rake'
import 'tasks/local.rake'
import 'tasks/test.rake'

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
