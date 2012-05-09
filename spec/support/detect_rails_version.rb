# Detects the current version of Rails that is being used
#
#
unless defined?(RAILS_VERSION_FILE)
  RAILS_VERSION_FILE = File.expand_path("../../../.rails-version", __FILE__)
end

unless defined?(DEFAULT_RAILS_VERSION)
  DEFAULT_RAILS_VERSION = "3.2.0"
end

def detect_rails_version
  version = version_from_file || version_from_env || DEFAULT_RAILS_VERSION

  puts "Detected Rails: #{version}" if ENV['DEBUG']

  version
end

def version_from_file
  if File.exists?(RAILS_VERSION_FILE)
    version = File.read(RAILS_VERSION_FILE).chomp.strip
    version = nil if version == ""

    version
  end
end

def version_from_env
  ENV['RAILS']
end

def write_rails_version(version)
  File.open(RAILS_VERSION_FILE, "w+"){|f| f << version }
end
