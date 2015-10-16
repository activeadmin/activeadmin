require File.join(File.dirname(__FILE__), "lib", "active_admin", "version")

Gem::Specification.new do |s|
  s.name          = 'activeadmin'
  s.license       = 'MIT'
  s.version       = ActiveAdmin::VERSION
  s.homepage      = 'http://activeadmin.info'
  s.authors       = ['Greg Bell']
  s.email         = ['gregdbell@gmail.com']
  s.description   = 'The administration framework for Ruby on Rails.'
  s.summary       = 'The administration framework for Ruby on Rails.'

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'arbre',               '~> 1.0', '>= 1.0.2'
  s.add_dependency 'bourbon'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'formtastic',          '~> 3.1'
  s.add_dependency 'formtastic_i18n'
  s.add_dependency 'inherited_resources', '~> 1.6'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'kaminari',            '~> 0.15'
  s.add_dependency 'rails',               '>= 3.2', '< 5.0'
  s.add_dependency 'ransack',             '~> 1.5.1'
  s.add_dependency 'sass-rails'

  # Gems for the development environment
  s.add_development_dependency "better_errors", "~> 2.1" # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  s.add_development_dependency "rack-mini-profiler", "~> 0.9" # Inline app profiler. See ?pp=help for options.
  s.add_development_dependency "yard", "~> 0.8" # Documentation generator

  # Gems for the development and test environments
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "rspec-rails", "~> 3.3"
  s.add_development_dependency "parallel_tests", "~> 1.5"
  s.add_development_dependency "devise", "~> 3.5"
  s.add_development_dependency "cancan", "~> 1.6"
  s.add_development_dependency "draper", "~> 2.1"
  s.add_development_dependency "pundit", "~> 1.0"
  s.add_development_dependency "pry", "~> 0.10" # Easily debug from your console with `binding.pry`
  # The following must also be required in the Gemfile with require: false
  s.add_development_dependency "rake", "~> 10.4"

  # Gems for the test environment
  s.add_development_dependency "capybara", "~> 2.5"
  s.add_development_dependency "database_cleaner", "~> 1.5"
  s.add_development_dependency "guard-rspec", "~> 4.6"
  s.add_development_dependency "jasmine", "~> 2.3"
  s.add_development_dependency "jslint_on_rails", "~> 1.1"
  s.add_development_dependency "launchy", "~> 2.4"
  s.add_development_dependency "rails-i18n", ">= 3.0.1" # Provides default i18n for many languages
  s.add_development_dependency "i18n-spec", "~> 0.6"
  s.add_development_dependency "poltergeist", "~> 1.7"
  s.add_development_dependency "test-unit", "~> 3.1" # As of Ruby 2.2 no longer in Ruby Standard Library, so must be made an explicit dependency
  # The following must also be required in the Gemfile with require: false
  s.add_development_dependency "cucumber-rails", "~> 1.4"
  s.add_development_dependency "simplecov", "~> 0.10" # Test coverage generator. Go to /coverage/ after running tests
  s.add_development_dependency "coveralls", "~> 0.8" # Test coverage website. Go to https://coveralls.io
  s.add_development_dependency "shoulda-matchers", ">= 2.8.0"
end
