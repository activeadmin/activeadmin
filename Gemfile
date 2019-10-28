source "https://rubygems.org"

group :development , :test do
  gem 'rake'
  gem 'pry' # Easily debug from your console with `binding.pry`
  gem 'pry-byebug', platform: :mri # Step-by-step debugging

  # Optional dependencies used in both development & test environments
  gem 'cancancan'
  gem 'pundit'
  gem 'jruby-openssl', '~> 0.10.1', platform: :jruby

  gem 'draper', '~> 3.1'
  gem "devise", "~> 4.7"

  gem "rails", "~> 6.0.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 60.0.rc1", platform: :jruby
end

group :test do
  gem 'apparition'
  gem 'capybara', '~> 3.14'
  gem 'db-query-matchers', '0.10.0'

  gem 'simplecov', '0.17.1', require: false # Test coverage generator. Go to /coverage/ after running tests
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'cucumber'
  gem 'database_cleaner'
  gem 'jasmine'
  gem 'jasmine-core', '2.99.2' # last release with Ruby 2.2 support.
  gem 'launchy'
  gem 'parallel_tests', '~> 2.26'
  gem 'rails-i18n' # Provides default i18n for many languages
  gem 'rspec-rails'
  gem "sqlite3", "~> 1.4", platform: :mri
end

group :release do
  gem 'chandler', '0.9.0' # Github releases from changelog
end

group :lint do
  # Code style
  gem 'rubocop', '0.75.1'
  gem 'rubocop-rspec', '~> 1.30'
  gem 'rubocop-rails', '~> 2.3'
  gem 'mdl', '0.6.0'

  # Translations
  gem 'i18n-tasks'
  gem 'i18n-spec'
end

group :docs do
  gem 'yard'     # Documentation generator
  gem 'kramdown' # Markdown implementation (for yard)
end

gemspec path: "."
