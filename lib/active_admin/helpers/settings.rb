require 'active_support/concern'

module ActiveAdmin

  # Adds a class method to a class to create settings with default values.
  #
  # Example:
  #
  #   class Configuration
  #     include ActiveAdmin::Settings
  #
  #     setting :site_title, "Default Site Title"
  #
  #     def initialize
  #       # You must call this method to initialize the defaults
  #       initialize_defaults!
  #     end
  #
  module Settings
    extend ActiveSupport::Concern

    module InstanceMethods

      def default_settings
        self.class.default_settings
      end

      def initialize_defaults!
        default_settings.each do |key, value|
          send("#{key}=".to_sym, value)
        end
      end

    end

    module ClassMethods

      def setting(name, default)
        default_settings[name] = default
        attr_accessor(name)
      end

      def default_settings
        @default_settings ||= {}
      end

    end
  end
end
