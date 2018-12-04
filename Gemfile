source "https://rubygems.org"

eval_gemfile(File.expand_path("Gemfile.common", __dir__))

group :release do
  gem 'chandler', git: 'https://github.com/deivid-rodriguez/chandler', branch: 'submit_link_references' # Github releases from changelog
end

group :lint do
  # Code style
  gem 'rubocop', '0.59.2'
  gem 'rubocop-rspec', '~> 1.30'
  gem 'mdl', '0.5.0'

  # Translations
  gem 'i18n-tasks'
  gem 'i18n-spec'
end

group :docs do
  gem 'yard'     # Documentation generator
  gem 'kramdown' # Markdown implementation (for yard)
end

gem "rails", "~> 5.2.1"
gem "devise", "~> 4.4"
gem "draper", "~> 3.0"
gem "activerecord-jdbcsqlite3-adapter", ">= 52.0", platforms: :jruby

gemspec path: "."
