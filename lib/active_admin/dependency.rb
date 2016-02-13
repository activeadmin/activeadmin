module ActiveAdmin
  module Dependency
    module Requirements
      DEVISE = '>= 3.2', '< 5'
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

    def self.rails5?
      rails >= '5.x'
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

      def adapter
        @adapter ||= Adapter.const_get(@name.camelize).new self
      end

      def method_missing(method, *args, &block)
        if respond_to_missing?(method)
          adapter.send method, *args, &block
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        adapter.respond_to?(method) || super
      rescue NameError
        # 🐾
      end
    end

    # Dependency adapters provide an easy way to wrap the conditional logic
    # necessary to support multiple versions of a gem.
    #
    # ActiveAdmin::Dependency.rails.adapter.parameterize 'a b'
    # => 'a_b'
    #
    # ActiveAdmin::Dependency.rails.parameterize 'a b'
    # => 'a_b'
    #
    # ActiveAdmin::Dependency.devise.adapter
    # -> NameError: uninitialized constant ActiveAdmin::Dependency::Adapter::Devise
    #
    module Adapter
      class Base
        def initialize(version)
          @version = version
        end
      end

      class Rails < Base
        def strong_parameters?
          @version >= 4 || defined?(ActionController::StrongParameters)
        end

        def parameterize(string)
          if Dependency.rails5?
            string.parameterize separator: '_'
          else
            string.parameterize '_'
          end
        end

        def redirect_back(controller, fallback_location)
          controller.instance_exec do
            if Dependency.rails5?
              redirect_back fallback_location: fallback_location
            elsif controller.request.headers.key? 'HTTP_REFERER'
              redirect_to :back
            else
              redirect_to fallback_location
            end
          end
        end

        def render_key
          Dependency.rails5? ? :body : :text
        end
      end
    end

  end
end
