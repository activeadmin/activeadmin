require_relative "changelog"

namespace :changelog do
  desc "Sync changelog from latest PR information"
  task :sync do
    Changelog.new.sync!
  end
end
