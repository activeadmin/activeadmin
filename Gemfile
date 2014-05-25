source 'https://rubygems.org'

gemspec

ACTIVE_ADMIN_PATH = File.dirname(__FILE__) unless defined?(ACTIVE_ADMIN_PATH)

require File.expand_path('spec/support/detect_rails_version', ACTIVE_ADMIN_PATH)

rails_version = detect_rails_version
gem 'rails', rails_version

gem 'arbre', github: 'gregbell/arbre' # until gregbell/arbre#16 makes it into an official release

gem 'sass-rails', '4.0.3' if rails_version[0] == '4' # #3005, #3093

# Optional dependencies
gem 'cancan'
gem 'devise'
gem 'draper'
gem 'pundit'

# Utility gems used in both development & test environments
gem 'rake', require: false
gem 'parallel_tests'

group :development do
  # Debugging
  gem 'pry'                # Easily debug from your console with `binding.pry`
  gem 'better_errors'      # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller'  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem 'rack-mini-profiler' # Inline app profiler. See ?pp=help for options.
  gem 'flamegraph'         # Flamegraph visualiztion: ?pp=flamegraph

  # Documentation
  gem 'yard'               # Documentation generator
  gem 'yard-redcarpet-ext' # Enables Markdown tables, which are disabled by default
  gem 'redcarpet'          # Markdown implementation (for yard)
end

group :test do
  gem 'capybara', '= 1.1.2'
  gem 'simplecov', require: false # Test coverage generator. Go to /coverage/ after running tests
  gem 'coveralls', require: false # Test coverage website. Go to https://coveralls.io
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'jasmine'
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n' # Provides default i18n for many languages
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end
