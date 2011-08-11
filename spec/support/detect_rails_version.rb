# Detects the current version of Rails that is being used
#
# You can pass it in as an ENV variable or it will use
# the current Gemfile.lock to find it
def detect_rails_version
  return nil unless (File.exists?("Gemfile.lock") || File.symlink?("Gemfile.lock"))

  File.read("Gemfile.lock").match(/^\W*rails \(([a-z\d.]*)\)/)
  return $1
end
