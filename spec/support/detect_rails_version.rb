def detect_rails_version
  version = ENV['BUNDLE_GEMFILE'].match(/rails_(.*).gemfile/)[1]
ensure
  puts "Detected Rails: #{version}" if ENV['DEBUG']
end

def detect_rails_version!
  detect_rails_version or raise "can't find a version of Rails to use!"
end
