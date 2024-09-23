# frozen_string_literal: true
require_relative "dynamic_setting"
require_relative "settings_node"

module ActiveAdmin

  class DynamicSettingsNode < SettingsNode
    class << self
      def register(name, value, type = nil)
        class_attribute "#{name}_setting"
        add_reader(name)
        add_writer(name, type)
        send :"#{name}=", value
      end

      def add_reader(name)
        define_singleton_method(name) do |*args|
          send(:"#{name}_setting").value(*args)
        end
      end

      def add_writer(name, type)
        define_singleton_method(:"#{name}=") do |value|
          send(:"#{name}_setting=", DynamicSetting.build(value, type))
        end
      end
    end
  end
end
