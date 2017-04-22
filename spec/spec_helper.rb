require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'features/'
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
