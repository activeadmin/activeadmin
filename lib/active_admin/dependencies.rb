module ActiveAdmin
  module Dependencies

    # Provides a simple query interface to check for gem dependencies
    #
    # ActiveAdmin::Dependencies.draper
    # => #<Gem::Specification:0x3ffb89c49ae0 draper-1.2.1>
    #
    # ActiveAdmin::Dependencies.draper?
    # => true
    #
    # ActiveAdmin::Dependencies.draper? :<=, '1.1.0'
    # => false
    #
    # ActiveAdmin::Dependencies.draper? :==, '1.2.1'
    # => true
    #
    def self.check_for(gem_name)
      gem_name = gem_name.to_s

      singleton_class.send :define_method, gem_name do
        Gem.loaded_specs[gem_name]
      end

      singleton_class.send :define_method, gem_name+'?' do |verb = nil, version = nil|
        spec = send gem_name
        if verb && version
          !!spec && spec.version.send(verb, Gem::Version.create(version))
        else
          !!spec
        end
      end
    end

    check_for :draper
    check_for :rails

  end
end
