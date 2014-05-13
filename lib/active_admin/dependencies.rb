module ActiveAdmin
  module Dependencies
    DEVISE = '~> 3.2.0'

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
    # ActiveAdmin::Dependencies.rails! '2'
    # -> ActiveAdmin::Dependencies::Error: You provided rails 3.2.18 but we need: 2.
    #
    # ActiveAdmin::Dependencies.devise!
    # -> ActiveAdmin::Dependencies::Error: To use devise you need to specify it in your Gemfile.
    #
    def self.check_for(gem_name)
      gem_name = gem_name.to_s

      singleton_class.send :define_method, gem_name do
        Gem.loaded_specs[gem_name]
      end

      singleton_class.send :define_method, gem_name+'?' do |*args|
        spec = send gem_name
        !!spec && Gem::Requirement.create(args).satisfied_by?(spec.version)
      end

      singleton_class.send :define_method, gem_name+'!' do |*args|
        unless send gem_name
          raise Error, "To use #{gem_name} you need to specify it in your Gemfile."
        end

        unless send gem_name+'?', *args
          raise Error, "You provided #{gem_name} #{send(gem_name).version} but we need: #{args.join ', '}."
        end
      end
    end

    check_for :cancan
    check_for :cancancan
    check_for :devise
    check_for :draper
    check_for :pundit
    check_for :rails

    class Error < ::ActiveAdmin::ErrorLoading; end

  end
end
