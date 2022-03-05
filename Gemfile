# frozen_string_literal: true
source "https://rubygems.org"

group :development, :test do
  gem "rake"
  gem "pry" # Easily debug from your console with `binding.pry`
  gem "pry-byebug", platform: :mri # Step-by-step debugging

  gem "cancancan"
  gem "pundit"

  gem "draper"
  gem "devise"

  gem "rails", "~> 7.0.0"

  gem "net-smtp" # The mail gem, depended on transitively, does not specify this dependency

  gem "sprockets-rails"
  gem "sassc-rails"
end

group :test do
  gem "cuprite"
  gem "capybara"
  gem "webrick"

  gem "simplecov", require: false # Test coverage generator. Go to /coverage/ after running tests
  gem "cucumber-rails", require: false
  gem "cucumber"
  gem "database_cleaner"
  gem "jasmine"
  gem "jasmine-core"
  gem "launchy"
  gem "parallel_tests"
  gem "rails-i18n" # Provides default i18n for many languages
  gem "rspec-rails"
  gem "sqlite3", platform: :mri
end

group :release do
  gem "chandler" # Github releases from changelog
  gem "octokit"
end

group :lint do
  # Code style
  gem "rubocop"
  gem "rubocop-packaging"
  gem "rubocop-rspec"
  gem "rubocop-rails"
  gem "mdl"

  # Translations
  gem "i18n-tasks"
  gem "i18n-spec"
end

group :docs do
  gem "yard" # Documentation generator
  gem "kramdown" # Markdown implementation (for yard)
end

gemspec path: "."
