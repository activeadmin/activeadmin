# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'active_admin/version' 

Gem::Specification.new do |s|
  s.name        = "active_admin"
  s.version     = ActiveAdmin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Greg Bell"]
  s.email       = ["gregdbell@gmail.com"]
  s.homepage    = "http://github.com/gregbell/active_admin"
  s.summary     = "The missing administration framework for Ruby on Rails"
  s.description = "ActiveAdmin DRY's your administration UI so that you can concentrate on what's actually important" 

  s.add_dependency 'inherited_views', '>= 0.0.1'
  
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.rdoc)
  s.require_path = 'lib'
end