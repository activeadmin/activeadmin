require 'active_admin/resource'

module ActiveAdmin
  class Resource
    class BelongsTo

      class TargetNotFound < StandardError; end

      # The resource which initiated this relationship
      attr_reader :owner

      def initialize(owner_resource, *symbols)
        options = symbols.extract_options!
        options.symbolize_keys!
        @owner = owner_resource
        @target_names = symbols
        @options      = options
      end

      # Returns the target resource class or raises an exception if it doesn't exist
      def targets
        @target_names.inject([]) do |array, target_name|
          target = namespace.resources.find_by_key(target_name.to_s.camelize) or
            raise TargetNotFound, "Could not find registered resource #{target_name} in #{namespace.name} with #{namespace.resources.inspect}"
          array << target
        end
      end

      def namespace
        @owner.namespace
      end

      def optional?
        @options[:optional]
      end

    end
  end
end
