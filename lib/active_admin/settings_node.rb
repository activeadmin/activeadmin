# frozen_string_literal: true
module ActiveAdmin

  class SettingsNode
    class << self
      # Never instantiated.  Variables are stored in the singleton_class.
      private_class_method :new

      # @return anonymous class with same accessors as the superclass.
      def build(superclass = self)
        Class.new(superclass)
      end

      def register(name, value)
        class_attribute name
        send "#{name}=", value
      end
    end
  end
end
