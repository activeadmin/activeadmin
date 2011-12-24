require File.expand_path('config/environments/cucumber', Rails.root)

Rails.application.class.configure do
  config.cache_classes = false
end
