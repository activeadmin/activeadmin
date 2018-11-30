require 'bundler/gem_tasks'

import 'tasks/docs.rake'
import 'tasks/gemfiles.rake'
import 'tasks/lint.rake'
import 'tasks/local.rake'
import 'tasks/release.rake'
import 'tasks/test.rake'

task default: :test

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end
