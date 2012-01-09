# Detects the current version of Rails that is being used
#
# You can pass it in as an ENV variable or it will use
# the current Gemfile.lock to find it

unless defined?(RAILS_VERSION_FILE)
  RAILS_VERSION_FILE = File.expand_path("../../../.rails-version", __FILE__)
end

def detect_rails_version
  return nil unless File.exists?(RAILS_VERSION_FILE)
  File.read(RAILS_VERSION_FILE).chomp
end

def write_rails_version(version)
  File.open(RAILS_VERSION_FILE, "w+"){|f| f << version }
end
