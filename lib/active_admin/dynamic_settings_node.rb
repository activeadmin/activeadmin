require 'active_admin/dynamic_setting'
require 'active_admin/settings_node'

module ActiveAdmin

  class DynamicSettingsNode < SettingsNode
    class << self
      def register(name, value)
        class_attribute "#{name}_setting"
        add_reader(name)
        add_writer(name)
        send "#{name}=", value
      end

      def add_reader(name)
        define_singleton_method(name) do
          send("#{name}_setting").value
        end
      end

      def add_writer(name)
        define_singleton_method("#{name}=") do |value|
          send("#{name}_setting=", DynamicSetting.build(value))
        end
      end
    end
  end
end
