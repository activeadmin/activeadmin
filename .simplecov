SimpleCov.start do
  add_filter 'tmp/development_apps/'
  add_filter 'tmp/test_apps/'
end

if ENV['CI'] == 'true'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter
  ]
end
