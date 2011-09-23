# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_admin/version"

Gem::Specification.new do |s|
  s.name          = %q{activeadmin}
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

  s.add_dependency("rails", ">= 3.0.0")
  s.add_dependency("meta_search", ">= 0.9.2")
  s.add_dependency("devise", ">= 1.1.2")
  s.add_dependency("formtastic", "< 2.0.0")
  s.add_dependency("inherited_resources", "< 1.3.0")
  s.add_dependency("kaminari", ">= 0.12.4")
  s.add_dependency("sass", ">= 3.1.0")
  s.add_dependency("fastercsv", ">= 0")
end
