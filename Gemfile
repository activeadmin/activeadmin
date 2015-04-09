source 'https://rubygems.org'

gemspec

require File.expand_path 'spec/support/detect_rails_version', File.dirname(__FILE__)

rails_version = detect_rails_version
gem 'rails', rails_version

gem 'execjs', '~> 2.4.0' # ~> 2.5.0 works only for Ruby > 2.0

# Optional dependencies
gem 'cancan'
gem 'devise'
gem 'draper'
gem 'pundit'

# Utility gems used in both development & test environments
gem 'rake', require: false
gem 'parallel_tests'

# Debugging
gem 'pry'                  # Easily debug from your console with `binding.pry`

group :development do
  # Debugging
  gem 'better_errors'      # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller'  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem 'rack-mini-profiler' # Inline app profiler. See ?pp=help for options.
  gem 'flamegraph'         # Flamegraph visualiztion: ?pp=flamegraph

  # Documentation
  gem 'yard'               # Documentation generator
  gem 'redcarpet'          # Markdown implementation (for yard)
end

group :test do
  gem 'capybara'
  gem 'simplecov', require: false # Test coverage generator. Go to /coverage/ after running tests
  gem 'coveralls', require: false # Test coverage website. Go to https://coveralls.io
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'jasmine'
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n' # Provides default i18n for many languages
  gem 'rspec'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'i18n-spec'
  gem 'shoulda-matchers'
  gem 'sqlite3'
  gem 'poltergeist'
end
