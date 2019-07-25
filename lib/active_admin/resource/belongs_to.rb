require 'active_admin/resource'

module ActiveAdmin
  class Resource
    class BelongsTo

      class TargetNotFound < StandardError
        def initialize(key, namespace)
          super "Could not find #{key} in #{namespace.name} " +
                "with #{namespace.resources.map(&:resource_name)}"
        end
      end

      # The resource which initiated this relationship
      attr_reader :owner

      def initialize(owner, target_name, options = {})
        @owner = owner
        @target_name = target_name
        @options = options
      end

      # Returns the target resource class or raises an exception if it doesn't exist
      def target
        resource or raise TargetNotFound.new (@options[:class_name] || @target_name.to_s.camelize), namespace
      end

      def resource
        namespace.resources[@options[:class_name]] ||
          namespace.resources[@target_name.to_s.camelize]
      end

      def namespace
        @owner.namespace
      end

      def optional?
        @options[:optional]
      end

      def required?
        !optional?
      end

      def to_param
        :"#{@target_name}_id"
      end
    end
  end
end
