source 'https://rubygems.org'

gemspec

require File.expand_path 'spec/support/detect_rails_version', File.dirname(__FILE__)

rails_version = detect_rails_version
gem 'rails', rails_version

gem 'jquery-ui-rails', rails_version[0] == '3' ? '~> 4.0' : '~> 5.0'

gem 'test-unit', '~> 3.0' if rails_version[0] == '3'

if rails_version == '> 5.x'
  # Note: when updating this list, be sure to also update the README
  gem 'ransack',    github: 'activerecord-hackery/ransack'
  gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
  gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'
  gem 'formtastic', github: 'justinfrench/formtastic'
  gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml' # drapergem/draper#697
  gem 'rack-mini-profiler', github: 'MiniProfiler/rack-mini-profiler'
  gem 'database_cleaner',  github: 'pschambacher/database_cleaner', branch: 'rails5.0', ref: '8dd9fa4'
  gem 'activerecord-jdbc-adapter', github: 'jruby/activerecord-jdbc-adapter', platforms: :jruby
end

# Optional dependencies
gem 'cancan'
gem 'devise', rails_version == '> 5.x' ? '> 4.x' : '~> 3.5'
gem 'draper' if rails_version != '> 5.x'
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
  gem 'rack-mini-profiler' if rails_version != '> 5.x' # Inline app profiler. See ?pp=help for options.
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
  gem 'database_cleaner' if rails_version != '> 5.x'
  gem 'guard-rspec', require: false
  gem 'jasmine'
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n'                          # Provides default i18n for many languages
  gem 'rspec-rails', '>= 3.5.0.beta1'
  gem 'i18n-spec'
  gem 'shoulda-matchers', '<= 2.8.0'
  gem 'sqlite3', platforms: :mri
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby if rails_version != '> 5.x'
  gem 'poltergeist'
end
