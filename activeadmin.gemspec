require File.join(File.dirname(__FILE__), "lib", "active_admin", "version")

Gem::Specification.new do |s|
  s.name          = 'activeadmin'
  s.license       = 'MIT'
  s.version       = ActiveAdmin::VERSION
  s.homepage      = 'https://activeadmin.info'
  s.authors       = ['Charles Maresh', 'David Rodríguez', 'Greg Bell', 'Igor Fedoronchuk', 'Javier Julio', 'Piers C', 'Sean Linsley', 'Timo Schilling']
  s.email         = ['deivid.rodriguez@riseup.net']
  s.description   = 'The administration framework for Ruby on Rails.'
  s.summary       = 'Active Admin is a Ruby on Rails plugin for generating ' \
    'administration style interfaces. It abstracts common business ' \
    'application patterns to make it simple for developers to implement ' \
    'beautiful and elegant interfaces with very little effort.'

  s.files         = `git ls-files LICENSE app config/locales docs lib vendor -z`.split("\x0")

  s.extra_rdoc_files = %w[CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md README.md]

  s.required_ruby_version = '>= 2.3'

  s.add_dependency 'arbre', '>= 1.1.1'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'formtastic', '~> 3.1'
  s.add_dependency 'formtastic_i18n'
  s.add_dependency 'inherited_resources', '>= 1.9.0'
  s.add_dependency 'jquery-rails', '>= 4.2.0'
  s.add_dependency 'kaminari', '>= 0.15'
  s.add_dependency 'railties', '>= 4.2', '< 5.3'
  s.add_dependency 'ransack', '>= 1.8.7'
  s.add_dependency 'sass', '~> 3.1'
  s.add_dependency 'sprockets', '< 4.1'
end
