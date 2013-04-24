require 'active_admin/resource'

module ActiveAdmin
  class Resource
    class BelongsTo

      class TargetNotFound < StandardError; end

      # The resource which initiated this relationship
      attr_reader :owner

      def initialize(owner, target_name, options = {})
        @owner, @target_name, @options = owner, target_name, options
      end

      # Returns the target resource class or raises an exception if it doesn't exist
      def target
        namespace.resources[@target_name.to_s.camelize] or raise TargetNotFound,
          "Could not find resource #{@target_name} in #{namespace.name} with #{namespace.resources}"
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
    end
  end
end
