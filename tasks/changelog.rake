require_relative "changelog"

namespace :changelog do
  desc "Add missing changelog references to the unreleased section"
  task :add_references do
    Changelog.new.add_references
  end
end
