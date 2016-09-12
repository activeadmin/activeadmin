ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require File.expand_path('../support/detect_rails_version', __FILE__)
ENV['RAILS'] = detect_rails_version

require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'features/'
  add_filter 'bundle/' # for Travis
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
