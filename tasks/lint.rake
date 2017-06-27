desc "Lints ActiveAdmin code base"
task lint: ["lint:rubocop", "lint:mdl"]

namespace :lint do
  require "rubocop/rake_task"
  desc "Checks ruby code style with RuboCop"
  RuboCop::RakeTask.new

  desc "Checks markdown code style with Markdownlint"
  task :mdl do
    puts "Running mdl..."
    abort unless system("mdl docs/*.md")
  end
end
