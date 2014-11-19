module ActiveAdmin
  module Formatter
    module DSL
      def inherited(klass)
        ActiveAdmin::Formatter.register klass
      end

      def detection(&block)
        define_method :detect do
          block.call(@object, @context)
        end
      end

      def formater(&block)
        define_method :process do
          block.call(@object, @context)
        end
      end

      class << self
        def extended(klass)
          ActiveAdmin::Formatter.register klass
        end
      end
    end
  end
end
