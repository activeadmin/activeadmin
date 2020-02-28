require 'active_admin/resource'

module ActiveAdmin
  class Resource
    class BelongsTo
      class NotSupported < StandardError; end

      class TargetNotFound < StandardError
        def initialize(key, namespace)
          super "Could not find #{key} in #{namespace.name} " +
                "with #{namespace.resources.map(&:resource_name)}"
        end
      end

      # The resource which initiated this relationship
      attr_reader :owner

      # The name of the relations
      attr_reader :target_names

      def initialize(owner, target_names, options = {})
        if target_names.size > 1 && !options[:optional]
          raise NotSupported, "Belongs to multiple parents must be optional"
        end

        @owner = owner
        @target_names = target_names
        @options = options
      end

      # Returns the target resource classes or raises an exception if one of the targets doesn't exist
      def targets
        target_names.map do |target_name|
          namespace.resources[@options[:class_name]] ||
            namespace.resources[target_name.to_s.camelize] ||
            raise(TargetNotFound.new((@options[:class_name] || target_name.to_s.camelize), namespace))
        end
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
        target_names.map { |target_name| :"#{target_name}_id" }
      end
    end
  end
end
