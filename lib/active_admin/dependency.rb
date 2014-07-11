module ActiveAdmin
  module Dependency
    DEVISE = '~> 3.2.0'

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
    # -> ActiveAdmin::Dependency::Error: You provided rails 3.2.18 but we need: 2.
    #
    # ActiveAdmin::Dependency.devise!
    # -> ActiveAdmin::Dependency::Error: To use devise you need to specify it in your Gemfile.
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
      def initialize(name)
        @name, @spec = name, Gem.loaded_specs[name]
      end

      def match?(*reqs)
        !!@spec && Gem::Requirement.create(reqs).satisfied_by?(@spec.version)
      end

      def match!(*reqs)
        unless @spec
          raise Error, "To use #{@name} you need to specify it in your Gemfile."
        end

        unless match? reqs
          raise Error, "You provided #{@spec.name} #{@spec.version} but we need: #{reqs.join ', '}."
        end
      end

      include Comparable

      def <=>(other)
        if @spec
          @spec.version <=> Gem::Version.create(other)
        else
          # you'd otherwise get an unhelpful error message:
          # ArgumentError: comparison of ActiveAdmin::Dependency::Matcher with 2 failed
          raise Error, "To use #{@name} you need to specify it in your Gemfile."
        end
      end

      def inspect
        info = @spec ? "#{@spec.name} #{@spec.version}" : '(missing)'
        "<ActiveAdmin::Dependency::Matcher for #{info}>"
      end
    end

    class Error < ::ActiveAdmin::ErrorLoading; end

  end
end
