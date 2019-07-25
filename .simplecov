SimpleCov.start do
  add_filter 'tmp/rails/'
end

if ENV['CI'] == 'true'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter
  ]
end
