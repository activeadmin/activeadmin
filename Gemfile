source 'http://rubygems.org'

gemspec

require File.expand_path('../spec/support/detect_rails_version', __FILE__)

rails_version = ENV['RAILS'] || detect_rails_version || "3.1.0"
gem 'rails',          rails_version
gem 'bourbon',  '1.0.4'

case rails_version
when /^3\.0/
  # Do nothing, bundler should figure it out
when /^3\.1/
  # These are the gems you have to have for Rails 3.1 to be happy
  gem 'sass-rails'
  gem 'uglifier'
else
  raise "Rails #{rails_version} is not supported yet"
end

group :development, :test do
  gem 'sqlite3-ruby',   :require => 'sqlite3'
  gem 'rake',           '0.8.7', :require => false
  gem 'haml',           '~> 3.1.1', :require => false
  gem 'yard'
  gem 'rdiscount' # For yard
end

group :test do
  gem 'rspec',          '~> 2.6.0'
  gem 'rspec-rails',    '~> 2.6.0'
  gem 'capybara',       '1.0.0'
  gem 'cucumber',       '0.10.6'
  gem 'cucumber-rails', '0.5.2'
  gem 'database_cleaner'
  gem 'shoulda',        '2.11.2',           :require => nil
  gem 'launchy'
  gem 'jslint_on_rails',    '~> 1.0.6'
  gem 'guard-rspec'
end
