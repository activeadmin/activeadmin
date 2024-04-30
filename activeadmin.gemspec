# frozen_string_literal: true
require File.join(__dir__, "lib", "active_admin", "version")

Gem::Specification.new do |s|
  s.name = "activeadmin"
  s.license = "MIT"
  s.version = ActiveAdmin::VERSION
  s.homepage = "https://activeadmin.info"
  s.authors = ["Charles Maresh", "David Rodríguez", "Greg Bell", "Igor Fedoronchuk", "Javier Julio", "Piers C", "Sean Linsley", "Timo Schilling"]
  s.email = ["deivid.rodriguez@riseup.net"]
  s.description = "The administration framework for Ruby on Rails."
  s.summary = "Active Admin is a Ruby on Rails plugin for generating " \
    "administration style interfaces. It abstracts common business " \
    "application patterns to make it simple for developers to implement " \
    "beautiful and elegant interfaces with very little effort."

  s.files = Dir["LICENSE", "{app,config/locales,lib,vendor/assets}/**/{.*,*}"].reject { |f| File.directory?(f) }

  s.extra_rdoc_files = %w[CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md README.md]

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/activeadmin/activeadmin/issues",
    "changelog_uri" => "https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://activeadmin.info",
    "homepage_uri" => "https://activeadmin.info",
    "mailing_list_uri" => "https://groups.google.com/group/activeadmin",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/activeadmin/activeadmin",
    "wiki_uri" => "https://github.com/activeadmin/activeadmin/wiki"
  }

  s.required_ruby_version = ">= 2.6"

  s.add_dependency "arbre", "~> 1.2", ">= 1.2.1"
  s.add_dependency "csv"
  s.add_dependency "formtastic", ">= 3.1"
  s.add_dependency "formtastic_i18n", ">= 0.4"
  s.add_dependency "inherited_resources", "~> 1.7"
  s.add_dependency "jquery-rails", ">= 4.2"
  s.add_dependency "kaminari", ">= 1.2.1"
  s.add_dependency "railties", ">= 6.1"
  s.add_dependency "ransack", ">= 4.0"
end
