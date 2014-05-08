module ActiveAdmin
  module Dependencies
    DEVISE_VERSION_REQUIREMENT = '~> 3.2.0'

    # Provides a simple query interface to check for gem dependencies
    #
    # ActiveAdmin::Dependencies.draper
    # => #<Gem::Specification:0x3ffb89c49ae0 draper-1.2.1>
    #
    # ActiveAdmin::Dependencies.draper?
    # => true
    #
    # ActiveAdmin::Dependencies.draper? '>= 1.1.0'
    # => false
    #
    # ActiveAdmin::Dependencies.draper? '= 1.2.1'
    # => true
    #
    # ActiveAdmin::Dependencies.draper? '~> 1.2.0'
    # => true
    #
    # ActiveAdmin::Dependencies.rails? '>= 4.1.0', '<= 4.1.1'
    # => true
    #
    def self.check_for(gem_name, *version_requirements)
      gem_name = gem_name.to_s

      singleton_class.send :define_method, gem_name do
        Gem.loaded_specs[gem_name]
      end

      singleton_class.send :define_method, gem_name+'?' do |*args|
        spec = send gem_name
        !!spec && Gem::Requirement.create(version_requirements + args).satisfied_by?(spec.version)
      end
    end

    check_for :draper
    check_for :rails
    check_for :devise, DEVISE_VERSION_REQUIREMENT
  end
end
