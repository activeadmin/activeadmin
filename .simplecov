SimpleCov.start do
  add_filter 'spec/rails/'
end

if ENV['CI'] == 'true'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter
  ]
end
