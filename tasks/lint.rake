desc "Lints ActiveAdmin code base"
task lint: ["lint:rubocop", "lint:mdl"]

namespace :lint do
  require "rubocop/rake_task"
  desc "Checks ruby code style with RuboCop"
  RuboCop::RakeTask.new

  desc "Checks markdown code style with Markdownlint"
  task :mdl do
    puts "Running mdl..."

    targets = [
      *Dir.glob("docs/**/*.md"),
      "CONTRIBUTING.md",
      ".github/ISSUE_TEMPLATE.md"
    ]

    abort unless system("mdl", *targets)
  end
end
