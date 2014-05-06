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
    # ActiveAdmin::Dependencies.rails? :between?, '4.1.0', '4.1.1'
    # => true
    #
    def self.check_for(gem_name)
      gem_name = gem_name.to_s

      singleton_class.send :define_method, gem_name do
        Gem.loaded_specs[gem_name]
      end

      singleton_class.send :define_method, gem_name+'?' do |verb = nil, *args|
        spec = send gem_name
        if verb
          !!spec && spec.version.send(verb, *args.map{ |v| Gem::Version.create(v) })
        else
          !!spec
        end
      end
    end

    check_for :draper
    check_for :rails

  end
end
