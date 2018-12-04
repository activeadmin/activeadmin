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

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|features)/})
  end

  s.required_ruby_version = '>= 2.3'

  s.add_dependency 'arbre', '>= 1.1.1'
  s.add_dependency 'formtastic', '~> 3.1'
  s.add_dependency 'formtastic_i18n'
  s.add_dependency 'inherited_resources', '>= 1.7.0'
  s.add_dependency 'jquery-rails', '>= 4.2.0'
  s.add_dependency 'kaminari', '>= 1.0.1'
  s.add_dependency 'railties', '>= 5.0', '< 5.3'
  s.add_dependency 'ransack', '>= 1.8.7'
  s.add_dependency 'sass', '~> 3.4'
  s.add_dependency 'sprockets', '>= 3.0', '< 4.1'
  s.add_dependency 'sprockets-es6', '>= 0.9.2'
end
