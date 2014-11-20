module ActiveAdmin
  module Formatter
    class << self
      attr_accessor :formatters

      def register(klass)
        self.formatters ||= []
        self.formatters.unshift klass
      end

      def unregister(klass)
        self.formatters.delete(klass)
      end

      def for(object, context)
        raise NoFormatterRegistered if formatters.empty?
        formatters.each do |formatter|
          f = formatter.new(object, context)
          return f if f.detect
        end
        raise NoFormatterFound, object
      end

      def format(object, context)
        self.for(object, context).process
      end
    end
  end
end

require "active_admin/formatter/dsl"
require "active_admin/formatter/base"
require "active_admin/formatter/date_time"
require "active_admin/formatter/arbre"
