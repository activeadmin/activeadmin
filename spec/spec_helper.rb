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
