require_relative "changelog"

namespace :changelog do
  desc "Syncronize latest release changelog with latest PR information"
  task :resync do
    Changelog.new.resync!
  end
end
