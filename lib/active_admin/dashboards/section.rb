module ActiveAdmin
  module Dashboards
    class Section

      @@renderers = {
        :default => SectionRenderer
      }
      cattr_accessor :renderers

      DEFAULT_PRIORITY = 10

      attr_accessor :name, :block
      attr_reader :namespace

      def initialize(namespace, name, options = {}, &block)
        @namespace = namespace
        @name = name
        @options = options
        @block = block
      end

      def priority
        @options[:priority] || DEFAULT_PRIORITY
      end

      def icon
        @options[:icon]
      end

      # Sort by priority then by name
      def <=>(other)
        result = priority <=> other.priority
        result = name.to_s <=> other.name.to_s if result == 0
        result
      end

      # Returns the class to use as this sections renderer. Raises
      # an exception if the renderer could not be found
      def renderer
        klass = Section.renderers[@options[:as] || :default]
        raise StandardError, "Could not find the #{@options[:as].inspect} dashboard section renderer." unless klass
        klass
      end

    end
  end
end
