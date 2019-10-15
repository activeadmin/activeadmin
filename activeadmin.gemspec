require File.join(__dir__, "lib", "active_admin", "version")

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

  s.required_ruby_version = '>= 2.4'

  s.add_dependency 'arbre', '~> 1.2', '>= 1.2.1'
  s.add_dependency 'formtastic', '~> 3.1'
  s.add_dependency 'formtastic_i18n', '~> 0.4'
  s.add_dependency 'inherited_resources', '~> 1.7'
  s.add_dependency 'jquery-rails', '~> 4.2'
  s.add_dependency 'kaminari', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'railties', '>= 5.2', '< 6.1'
  s.add_dependency 'ransack', '~> 2.1', '>= 2.1.1'
  s.add_dependency 'sassc-rails', '~> 2.1'
  s.add_dependency 'sprockets', '>= 3.0', '< 4.1'
end
