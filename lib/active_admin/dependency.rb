module ActiveAdmin
  module Dependency
    DEVISE = '~> 3.2.0'

    # Provides a clean interface to check for gem dependencies at runtime.
    #
    # ActiveAdmin::Dependency.draper
    # => #<Gem::Specification:0x3ffb89c49ae0 draper-1.2.1>
    #
    # ActiveAdmin::Dependency.draper?
    # => true
    #
    # ActiveAdmin::Dependency.draper? '>= 1.1.0'
    # => false
    #
    # ActiveAdmin::Dependency.draper? '= 1.2.1'
    # => true
    #
    # ActiveAdmin::Dependency.draper? '~> 1.2.0'
    # => true
    #
    # ActiveAdmin::Dependency.rails? '>= 4.1.0', '<= 4.1.1'
    # => true
    #
    # ActiveAdmin::Dependency.rails! '2'
    # -> ActiveAdmin::Dependency::Error: You provided rails 3.2.18 but we need: 2.
    #
    # ActiveAdmin::Dependency.devise!
    # -> ActiveAdmin::Dependency::Error: To use devise you need to specify it in your Gemfile.
    #
    def self.method_missing(name, *args)
      if name[-1] == '?'
        Matcher.match? name[0...-1], args
      elsif name[-1] == '!'
        Matcher.match! name[0...-1], args
      else
        Matcher.find_spec name.to_s
      end
    end

    module Matcher
      def self.find_spec(name)
        Gem.loaded_specs[name]
      end

      def self.match?(name, reqs)
        spec = find_spec name
        !!spec && Gem::Requirement.create(reqs).satisfied_by?(spec.version)
      end

      def self.match!(name, reqs)
        unless find_spec name
          raise Error, "To use #{name} you need to specify it in your Gemfile."
        end

        unless match? name, reqs
          raise Error, "You provided #{name} #{find_spec(name).version} but we need: #{reqs.join ', '}."
        end
      end
    end

    class Error < ::ActiveAdmin::ErrorLoading; end

  end
end
