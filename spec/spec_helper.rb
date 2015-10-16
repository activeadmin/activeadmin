$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path('../support', __FILE__)

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
require "bundler"
Bundler.setup

# Run tests with NOCOVER=true to skip code coverage
unless ENV["NOCOVER"]
  # Code coverage libraries must be required before all application / gem / library code.
  require 'simplecov'

  SimpleCov.start do
    add_filter 'spec/'
    add_filter 'features/'
    add_filter 'bundle/' # for Travis
  end
end
