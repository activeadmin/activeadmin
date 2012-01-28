# Detects the current version of Rails that is being used
#
# You can pass it in as an ENV variable or it will use
# the current Gemfile.lock to find it

unless defined?(RAILS_VERSION_FILE)
  RAILS_VERSION_FILE = File.expand_path("../../../.rails-version", __FILE__)
end

unless defined?(DEFAULT_RAILS_VERSION)
  DEFAULT_RAILS_VERSION = "3.2.0"
end

def detect_rails_version
  detected_version = if File.exists?(RAILS_VERSION_FILE)
    version = File.read(RAILS_VERSION_FILE).chomp.strip
    version != "" ? version : DEFAULT_RAILS_VERSION
  else
    DEFAULT_RAILS_VERSION
  end

  puts "Detected Rails: #{detected_version}" if ENV['DEBUG']

  detected_version
end

def write_rails_version(version)
  File.open(RAILS_VERSION_FILE, "w+"){|f| f << version }
end
