module ActiveAdmin
  module Dashboards
    class Section

      DEFAULT_PRIORITY = 10

      attr_accessor :name, :block
      attr_reader :namespace, :options

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

    end
  end
end
