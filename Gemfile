# These resources are needed to setup the test env
source 'http://rubygems.org'

# Set the RAILS env variable to test against diffirent versions of rails
case ENV["RAILS"]
when "3.0.0"
  gem 'rails',          '= 3.0.0'
when "3.0.1"
  gem 'rails',          '= 3.0.1'
when "3.0.2"
  gem 'rails',          '= 3.0.2'
when "3.0.3"
  gem 'rails',          '= 3.0.3'
when "3.0.4"
  gem 'rails',          '= 3.0.4'
when "3.0.5"
  gem 'rails',          '= 3.0.5'
when "3.0.6"
  gem 'rails',          '= 3.0.6'
when "3.0.7"
  gem 'rails',          '= 3.0.7'
else
  # Default gems for in the gemspec
  gem 'rails',          '>= 3.0.0'
end

gem "meta_search",    '>= 0.9.2'
gem 'devise',         '>= 1.1.2'
gem 'formtastic',     '>= 1.1.0'
gem 'will_paginate',  '>= 3.0.pre2'
gem 'inherited_views'
gem 'sass',           '>= 3.1.0'

group :development, :test do
  gem 'sqlite3-ruby',   :require => 'sqlite3'
  gem 'jeweler',        '1.5.2'
  gem 'rake',           '0.8.7', :require => false
  gem 'haml',           '~> 3.1.1', :require => false
end

group :test do
  gem 'rspec',          '~> 2.6.0'
  gem 'rspec-rails',    '~> 2.6.0'
  gem 'capybara',       '0.3.9'
  gem 'cucumber',       '0.9.2'
  gem 'cucumber-rails', '0.3.2'
  gem 'database_cleaner'
  gem 'shoulda',        '2.11.2',           :require => nil
  gem 'launchy'
end
