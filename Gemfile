source 'https://rubygems.org'

gemspec

ACTIVE_ADMIN_PATH = File.dirname(__FILE__) unless defined?(ACTIVE_ADMIN_PATH)

require File.expand_path('spec/support/detect_rails_version', ACTIVE_ADMIN_PATH)

rails_version = detect_rails_version
gem 'rails', rails_version

group :development do
  gem 'better_errors',     '~> 1.0.0' # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller', '~> 0.7.1' # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2
end

group :development, :test do
  gem 'rake', '~> 10.1.0', require: false
  gem 'rails-i18n' # Provides default i18n for many languages
  gem 'redcarpet'  # Markdown implementation (for yard)
  gem 'yard'
  gem 'yard-redcarpet-ext' # Enables Markdown tables, which are disabled by default
end

group :test do
  gem 'cancan'
  gem 'capybara',         '=  1.1.2'
  gem 'simplecov',                    require: false
  gem 'coveralls',        '~> 0.7.0', require: false # Test coverage tool: www.coveralls.io
  # Move to next stable version including: https://github.com/cucumber/cucumber-rails/pull/253
  gem 'cucumber-rails',   github: 'cucumber/cucumber-rails', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'guard-rspec'
  gem 'jasmine'
  gem 'jslint_on_rails',  '~> 1.1.1'
  gem 'launchy'
  gem 'parallel_tests'
  gem 'rspec-rails',      '~> 2.14.0'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end
