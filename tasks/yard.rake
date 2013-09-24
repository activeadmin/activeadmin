require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new do |t|
  t.after = proc { Rake::Task['docs:build'].invoke }
  t.files = ['lib/**/*.rb']
end
