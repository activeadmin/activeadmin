desc "Lints ActiveAdmin code base"
task lint: ["lint:rubocop"]

namespace :lint do
  require "rubocop/rake_task"
  desc "Checks ruby code style with RuboCop"
  RuboCop::RakeTask.new
end
