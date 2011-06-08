# These resources are needed to setup the test env
source 'http://rubygems.org'

# Set the RAILS env variable to test against diffirent versions of rails
case ENV["RAILS"]
when /3.0.(\d)*/
  gem 'rails',          "= 3.0.#{$1}"
  gem "meta_search",    '~> 1.0.0'
when "3.1.0.rc1"
  gem 'rails',          '= 3.1.0.rc1'
  gem "meta_search",    '>= 1.1.0.pre'
else
  # Default gems for in the gemspec
  gem 'rails',          '>= 3.0.0'
  gem "meta_search",    '>= 1.0.0'
end


gem 'devise',         '>= 1.1.2'
gem 'formtastic',     '>= 1.1.0'
gem 'inherited_resources'
gem 'kaminari',       '>= 0.12.4'
gem 'sass',           '>= 3.1.0'
gem 'fastercsv'

group :development, :test do
  gem 'sqlite3-ruby',   :require => 'sqlite3'
  gem 'jeweler',        '1.5.2'
  gem 'rake',           '0.8.7', :require => false
  gem 'haml',           '~> 3.1.1', :require => false
end

group :test do
  gem 'rspec',          '~> 2.6.0'
  gem 'rspec-rails',    '~> 2.6.0'
  gem 'capybara',       '1.0.0.beta1'
  gem 'cucumber',       '0.10.3'
  gem 'cucumber-rails', '0.5.1'
  gem 'database_cleaner'
  gem 'shoulda',        '2.11.2',           :require => nil
  gem 'launchy'
end

