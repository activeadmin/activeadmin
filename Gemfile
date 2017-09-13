source 'https://rubygems.org'

# Trick to use https without warnings and without having to specify full URLs
# TODO: Can be removed when Bundler 2.x is released.
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Optional dependencies
gem 'cancan'
gem 'pundit'

# Utility gems used in both development & test environments
gem 'rake'
gem 'parallel_tests'

# Debugging
gem 'pry' # Easily debug from your console with `binding.pry`

# Code style
gem 'rubocop', '0.49.1'
gem 'mdl', '0.4.0'

# Translations
gem 'i18n-tasks'

# Documentation
gem 'yard'                        # Documentation generator
gem 'redcarpet', platforms: :mri  # Markdown implementation (for yard)
gem 'kramdown', platforms: :jruby # Markdown implementation (for yard)

group :development do
  # Debugging
  gem 'better_errors' # Web UI to debug exceptions. Go to /__better_errors to access the latest one

  gem 'binding_of_caller', platforms: :mri # Retrieve the binding of a method's caller

  # Performance
  gem 'rack-mini-profiler' # Inline app profiler. See ?pp=help for options.
end

group :test do
  gem 'capybara'
  gem 'simplecov', require: false # Test coverage generator. Go to /coverage/ after running tests
  gem 'codecov', require: false # Test coverage website. Go to https://codecov.io
  gem 'cucumber-rails', require: false
  gem 'cucumber'
  gem 'database_cleaner'
  gem 'jasmine'
  gem 'launchy'
  gem 'rails-i18n' # Provides default i18n for many languages
  gem 'rspec-rails'
  gem 'i18n-spec'
  gem 'shoulda-matchers', '<= 2.8.0'
  gem 'sqlite3', platforms: :mri
  gem 'poltergeist'
end
