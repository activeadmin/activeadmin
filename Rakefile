require 'bundler/gem_tasks'

import 'tasks/gemfiles.rake'
import 'tasks/local.rake'
import 'tasks/test.rake'

gemfile = ENV['BUNDLE_GEMFILE']

if gemfile.nil? || File.expand_path(gemfile) == File.expand_path('Gemfile')
  import 'tasks/docs.rake'
  import 'tasks/lint.rake'
  import 'tasks/release.rake'
end

task default: :test

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end
