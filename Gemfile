# frozen_string_literal: true
source "https://rubygems.org"

group :development, :test do
  gem "rake"

  gem "cancancan"
  gem "pundit"

  gem "draper"
  gem "devise"

  gem "rails", "~> 7.2.0.beta2"

  gem "sprockets-rails"
  gem 'ransack', github: 'saltlabsinc/ransack', branch: 'delegate-alias-tracker-to-relation-1491' # TODO: activerecord-hackery/ransack#1493
  gem "formtastic", ">= 5.0.0"

  gem "cssbundling-rails"
  gem "importmap-rails"
end

group :test do
  gem "cuprite"
  gem "capybara"
  gem "webrick"

  gem "simplecov", require: false # Test coverage generator. Go to /coverage/ after running tests
  gem "simplecov-cobertura", require: false
  gem "cucumber-rails", require: false
  gem "cucumber"
  # TODO: use stable when DatabaseCleaner/database_cleaner-active_record#102 will be released
  gem 'database_cleaner-active_record', github: 'DatabaseCleaner/database_cleaner-active_record'
  gem "launchy"
  gem "parallel_tests"
  gem "rspec-rails"
  gem "sqlite3", platform: :mri

  # Translations
  gem "i18n-tasks"
  gem "i18n-spec"
  gem "rails-i18n" # Provides default i18n for many languages
end

group :rubocop do
  gem "rubocop"
  gem "rubocop-capybara"
  gem "rubocop-packaging"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rails"
end

group :docs do
  gem "yard" # Documentation generator
  gem "kramdown" # Markdown implementation (for yard)
end

gemspec path: "."
