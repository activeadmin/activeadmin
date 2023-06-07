# frozen_string_literal: true
source "https://rubygems.org"

group :development, :test do
  gem "rake"

  gem "cancancan"
  gem "pundit"

  gem "draper"
  gem "devise"

  gem "rails", "~> 7.0.0"

  gem "sprockets-rails"
  gem "sassc-rails"
end

group :test do
  gem "cuprite"
  gem "capybara"
  gem "webrick"

  gem "simplecov", require: false # Test coverage generator. Go to /coverage/ after running tests
  gem "simplecov-cobertura"
  gem "cucumber-rails", require: false
  gem "cucumber"
  gem "database_cleaner"
  gem "launchy"
  gem "parallel_tests"
  gem "rspec-rails"
  gem "sqlite3", platform: :mri

  # Translations
  gem "i18n-tasks"
  gem "i18n-spec"
  gem "rails-i18n" # Provides default i18n for many languages
end

group :release do
  gem "chandler" # Github releases from changelog
  gem "octokit"
end

group :rubocop do
  gem "rubocop"
  gem "rubocop-packaging"
  gem "rubocop-rspec"
  gem "rubocop-rails"
end

group :docs do
  gem "yard" # Documentation generator
  gem "kramdown" # Markdown implementation (for yard)
end

gemspec path: "."
