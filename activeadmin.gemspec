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

  s.add_dependency "arbre",               "~> 1.0"
  s.add_dependency "bourbon"
  s.add_dependency "coffee-rails"
  s.add_dependency "devise",              "~> 3.0"
  s.add_dependency "formtastic",          "~> 2.3.0.rc2" # change to 2.3 when stable is released
  s.add_dependency "inherited_resources", "~> 1.3"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "kaminari",            "~> 0.15"
  s.add_dependency "rails",               ">= 3.2", "< 4.1"
  s.add_dependency "ransack",             "~> 1.0"
  s.add_dependency "sass-rails"
end
