source 'http://rubygems.org'

gemspec

require File.expand_path('../spec/support/detect_rails_version', __FILE__)

rails_version = detect_rails_version
gem 'rails',          rails_version
gem 'bourbon'

case rails_version
when /^3\.0/
  # Do nothing, bundler should figure it out
when /^3\.(1|2)/
  # These are the gems you have to have for Rails 3.1 to be happy
  gem 'sass-rails'
  gem 'uglifier'
else
  raise "Rails #{rails_version} is not supported yet"
end

group :development, :test do
  gem 'sqlite3-ruby',   :require => 'sqlite3'

  gem 'rake',           '~> 0.9.2.2', :require => false
  gem 'haml',           '~> 3.1.1', :require => false
  gem 'yard'
  gem 'rdiscount' # For yard
  gem "guard-sprockets"
end

group :test do
  gem 'rspec-rails',    '~> 2.8.1'
  gem 'cucumber', '1.1.4'
  gem 'cucumber-rails', '1.2.1'
  gem 'capybara',       '1.1.2'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '1.0.0'
  gem 'launchy'
  gem 'jslint_on_rails',    '~> 1.0.6'
  gem 'guard-rspec'
  gem "guard-coffeescript"
  gem 'jasmine'
end
