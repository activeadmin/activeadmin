SimpleCov.start do
  add_filter 'spec/rails/'
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Codecov
  ]
end
