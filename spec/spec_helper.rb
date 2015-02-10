$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path('../support', __FILE__)

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
require "bundler"
Bundler.setup

require 'detect_rails_version'
ENV['RAILS'] = detect_rails_version

require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'features/'
  add_filter 'bundle/' # for Travis
end
