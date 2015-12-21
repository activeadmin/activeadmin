module ActiveAdmin
  module Dependency
    module Requirements
      DEVISE = '~> 3.2'
    end

    # Provides a clean interface to check for gem dependencies at runtime.
    #
    # ActiveAdmin::Dependency.draper
    # => #<ActiveAdmin::Dependency::Matcher for draper 1.2.1>
    #
    # ActiveAdmin::Dependency.draper?
    # => true
    #
    # ActiveAdmin::Dependency.draper? '>= 1.5.0'
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
    # -> ActiveAdmin::DependencyError: You provided rails 3.2.18 but we need: 2.
    #
    # ActiveAdmin::Dependency.devise!
    # -> ActiveAdmin::DependencyError: To use devise you need to specify it in your Gemfile.
    #
    #
    # All but the pessimistic operator (~>) can also be run using Ruby's comparison syntax.
    #
    # ActiveAdmin::Dependency.rails >= '3.2.18'
    # => true
    #
    # Which is especially useful if you're looking up a gem with dashes in the name.
    #
    # ActiveAdmin::Dependency['jquery-ui-rails'] < 5
    # => false
    #
    def self.method_missing(name, *args)
      if name[-1] == '?'
        Matcher.new(name[0..-2]).match? args
      elsif name[-1] == '!'
        Matcher.new(name[0..-2]).match! args
      else
        Matcher.new name.to_s
      end
    end

    def self.[](name)
      Matcher.new name.to_s
    end

    class Matcher
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def spec
        @spec ||= Gem.loaded_specs[name]
      end

      def spec!
        spec || raise(DependencyError, "To use #{name} you need to specify it in your Gemfile.")
      end

      def match?(*reqs)
        !!spec && Gem::Requirement.create(reqs).satisfied_by?(spec.version)
      end

      def match!(*reqs)
        unless match? reqs
          raise DependencyError, "You provided #{spec!.name} #{spec!.version} but we need: #{reqs.join ', '}."
        end
      end

      include Comparable

      def <=>(other)
        spec!.version <=> Gem::Version.create(other)
      end

      def inspect
        info = spec ? "#{spec.name} #{spec.version}" : '(missing)'
        "<ActiveAdmin::Dependency::Matcher for #{info}>"
      end
    end
  end
end
