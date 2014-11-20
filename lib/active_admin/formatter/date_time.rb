module ActiveAdmin
  module Formatter
    class DateTime < Base
      detection do |object|
        object.is_a?(::Date) || object.is_a?(::Time)
      end

      formater do |object, context|
        context.localize object, format: :long
      end
    end
  end
end
