source 'https://rubygems.org'

gemspec

require File.expand_path 'spec/support/detect_rails_version', File.dirname(__FILE__)

rails_version = detect_rails_version
rails_major   = rails_version[0]

gem 'rails', rails_version

gem 'jquery-ui-rails', rails_major == '3' ? '~> 4.0' : '~> 5.0'

gem 'test-unit', '~> 3.0' if rails_major == '3'

if rails_major == '5'
  # Note: when updating this list, be sure to also update the README
  gem 'sass-rails',          github: 'rails/sass-rails'
  gem 'inherited_resources', github: 'activeadmin/inherited_resources'
  gem 'ransack',             github: 'activerecord-hackery/ransack'
end

gem 'mime-types', '< 3' # Remove this line when we drop support for Ruby 1.9

# Optional dependencies
gem 'cancan'
gem 'devise', rails_major == '5' ? '> 4.x' : '~> 3.5'
gem 'draper', rails_major == '5' ? '> 3.x' : '~> 2.1'
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

  # Flamegraph dependency
  gem 'stackprof', platforms: [:mri_21, :mri_22, :mri_23], require: false
  gem 'fast_track', platforms: [:mri_19, :mri_20], require: false

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
  gem 'guard-rspec', require: false
  gem 'listen', '~> 2.7', platforms: :ruby_19
  gem 'jasmine'
  gem 'phantomjs', '1.9.8.0'                # Same version as Travis CI's pre-installed version
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n'                          # Provides default i18n for many languages
  gem 'rspec-rails', '>= 3.5.0.beta1'
  gem 'i18n-spec'
  gem 'shoulda-matchers', '<= 2.8.0'
  gem 'sqlite3', platforms: :mri
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'poltergeist'
  gem 'tins', '1.6.0'
end
