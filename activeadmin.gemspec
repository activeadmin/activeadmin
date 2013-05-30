# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_admin/version"

Gem::Specification.new do |s|
  s.name          = %q{activeadmin}
  s.license       = "MIT"
  s.version       = ActiveAdmin::VERSION
  s.platform      = Gem::Platform::RUBY
  s.homepage      = %q{http://activeadmin.info}
  s.authors       = ["Greg Bell"]
  s.email         = ["gregdbell@gmail.com"]
  s.description   = %q{The administration framework for Ruby on Rails.}
  s.summary       = %q{The administration framework for Ruby on Rails.}

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "arbre",               ">= 1.0.1"
  s.add_dependency "bourbon",             ">= 1.0.0"
  s.add_dependency "coffee-rails",        ">= 3.2.0"
  s.add_dependency "devise",              ">= 3.0.0.rc"
  s.add_dependency "formtastic",          ">= 2.0.0"
  s.add_dependency "inherited_resources", ">= 1.3.1"
  s.add_dependency "jquery-rails",        ">= 3.0.0"
  s.add_dependency "jquery-ui-rails",     ">= 4.0.0"
  s.add_dependency "kaminari",            ">= 0.13.0"
  s.add_dependency "rails",               ">= 3.2.0"
  s.add_dependency "ransack",             ">= 0.7.0"
  s.add_dependency "sass-rails",          ">= 3.2.3"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "better_errors", "~> 0.8.0" # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  s.add_development_dependency "binding_of_caller", "~> 0.7.1" # Retrieve the binding of a method"s caller in MRI Ruby >= 1.9.2
  s.add_development_dependency "rake"
  s.add_development_dependency "rails-i18n" # Provides default i18n for many languages
  s.add_development_dependency "rdiscount"  # Markdown implementation  for yard
  s.add_development_dependency "sprockets"
  s.add_development_dependency "yard"
  s.add_development_dependency "cancan"
  s.add_development_dependency "capybara", "1.1.2"
  s.add_development_dependency "cucumber-rails", "1.3.0"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "guard-coffeescript"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "jasmine"
  s.add_development_dependency "jslint_on_rails", "~> 1.1.1"
  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails", "~> 2.9.0"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
end
