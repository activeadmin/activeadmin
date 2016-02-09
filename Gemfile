source 'https://rubygems.org'

gemspec

require File.expand_path 'spec/support/detect_rails_version', File.dirname(__FILE__)

rails_version = detect_rails_version
gem 'rails', rails_version == 'master' ? {github: 'rails/rails'} : rails_version

gem 'jquery-ui-rails', rails_version[0] == '3' ? '~> 4.0' : '~> 5.0'

gem 'test-unit', '~> 3.0' if rails_version[0] == '3'

if rails_version == 'master'
  gem 'arel',       github: 'rails/arel'
  gem 'sprockets',  github: 'rails/sprockets'
  gem 'sass-rails', github: 'rails/sass-rails'
  gem 'rack',       github: 'rack/rack'
  gem 'sprockets-rails', '3.0.0.beta2'
end

# Optional dependencies
gem 'cancan'
gem 'devise'
gem 'draper'
gem 'pundit'

# Utility gems used in both development & test environments
gem 'rake', require: false
gem 'parallel_tests'

# Debugging
gem 'pry'                                   # Easily debug from your console with `binding.pry`

group :development do
  # Debugging
  gem 'better_errors'                       # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller', platforms: :mri  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem 'rack-mini-profiler'                  # Inline app profiler. See ?pp=help for options.
  gem 'flamegraph', platforms: :mri         # Flamegraph visualiztion: ?pp=flamegraph

  # Documentation
  gem 'yard'                                # Documentation generator
  gem 'redcarpet', platforms: :mri          # Markdown implementation (for yard)
  gem 'kramdown', platforms: :jruby         # Markdown implementation (for yard)
end

group :test do
  gem 'capybara'
  gem 'simplecov', require: false           # Test coverage generator. Go to /coverage/ after running tests
  gem 'coveralls', require: false           # Test coverage website. Go to https://coveralls.io
  gem 'cucumber-rails', require: false
  gem 'cucumber', '1.3.20'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'jasmine'
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n'                          # Provides default i18n for many languages
  gem 'rspec'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'i18n-spec'
  gem 'i18n-tasks', rails_version[0] == '3' ? '~> 0.8.7' : '~> 0.9.4', platforms: [:ruby_21, :ruby_22]
  gem 'shoulda-matchers', '<= 2.8.0'
  gem 'sqlite3', platforms: :mri
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'poltergeist'
end
