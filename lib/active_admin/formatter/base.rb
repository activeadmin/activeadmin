module ActiveAdmin
  module Formatter
    class Base
      extend ActiveAdmin::Formatter::DSL

      def initialize(object, context)
        @object, @context = object, context
      end

      detection do |object, context|
        true
      end

      formater do |object, context|
        object.to_s
      end
    end
  end
end
