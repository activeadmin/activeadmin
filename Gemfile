source 'https://rubygems.org'

# Optional dependencies
gem 'cancan'
gem 'pundit'

# Until https://github.com/erikhuda/thor/issues/538 fixed
gem 'thor', '<= 0.19.1'

# Utility gems used in both development & test environments
gem 'rake'
gem 'parallel_tests', '< 2.10' #2.10 requires ruby '>= 2.0.0'

# Debugging
gem 'pry'                                   # Easily debug from your console with `binding.pry`

group :development do
  # Debugging
  gem 'better_errors',                      # Web UI to debug exceptions. Go to /__better_errors to access the latest one
      platforms: [:ruby_20, :ruby_21, :ruby_22, :ruby_23]

  gem 'binding_of_caller', platforms: :mri  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem 'rack-mini-profiler'                  # Inline app profiler. See ?pp=help for options.
  gem 'flamegraph', platforms: :mri         # Flamegraph visualiztion: ?pp=flamegraph

  # Flamegraph dependency
  gem 'stackprof', platforms: [:mri_21, :mri_22, :mri_23], require: false
  gem 'fast_stack', platforms: [:mri_19, :mri_20], require: false

  # Documentation
  gem 'yard'                                # Documentation generator
  gem 'redcarpet', platforms: :mri          # Markdown implementation (for yard)
  gem 'kramdown', platforms: :jruby         # Markdown implementation (for yard)
  gem 'appraisal', require: false
end

group :test do
  gem 'capybara'
  gem 'simplecov', require: false           # Test coverage generator. Go to /coverage/ after running tests
  gem 'codecov', require: false             # Test coverage website. Go to https://codecov.io
  gem 'cucumber-rails', require: false
  gem 'cucumber', '1.3.20'
  gem 'database_cleaner'
  gem 'jasmine'
  gem 'jslint_on_rails'
  gem 'launchy'
  gem 'rails-i18n'                          # Provides default i18n for many languages
  gem 'rspec-rails'
  gem 'i18n-spec'
  gem 'shoulda-matchers', '<= 2.8.0'
  gem 'sqlite3', platforms: :mri
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'poltergeist'
end
