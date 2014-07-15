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
        resource or raise TargetNotFound, "Could not find #{@options[:class_name] || @target_name.to_s.camelize} in" +
          " #{namespace.name.to_s} with #{namespace.resources.map(&:resource_name)}"
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
    end
  end
end
