module ActiveAdmin

  # Adds a class method to a class to create settings with default values.
  #
  # Example:
  #
  #   class Configuration
  #     include ActiveAdmin::Settings
  #
  #     setting :site_title, "Default Site Title"
  #   end
  #
  #   conf = Configuration.new
  #   conf.site_title #=> "Default Site Title"
  #   conf.site_title = "Override Default"
  #   conf.site_title #=> "Override Default"
  #
  module Settings

    def self.included(base)
      base.extend ClassMethods
    end

    def read_default_setting(name)
      default_settings[name]
    end

    private

    def default_settings
      self.class.default_settings
    end

    module ClassMethods

      def setting(name, default)
        default_settings[name] = default
        attr_writer name

        # Create an accessor that looks up the default value if none is set.
        define_method name do
          if instance_variable_defined? "@#{name}"
            instance_variable_get "@#{name}"
          else
            read_default_setting name.to_sym
          end
        end
      end

      def deprecated_setting(name, default, message = nil)
        setting(name, default)

        message ||= "The #{name} setting is deprecated and will be removed."
        ActiveAdmin::Deprecation.deprecate self,     name,    message
        ActiveAdmin::Deprecation.deprecate self, :"#{name}=", message
      end

      def default_settings
        @default_settings ||= {}
      end

    end


    # Allows you to define child classes that should receive the same
    # settings, as well as the same default values.
    #
    # Example from the codebase:
    #
    #   class Application
    #     include Settings
    #     include Settings::Inheritance
    #
    #     settings_inherited_by :Namespace
    #
    #     inheritable_setting :root_to, 'dashboard#index'
    #   end
    #
    module Inheritance

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def settings_inherited_by(heir)
          (@setting_heirs ||= []) << heir
          heir.send :include, ActiveAdmin::Settings
        end

        def inheritable_setting(name, default)
          setting name, default
          @setting_heirs.each{ |c| c.setting name, default }
        end

        def deprecated_inheritable_setting(name, default)
          deprecated_setting name, default
          @setting_heirs.each{ |c| c.deprecated_setting name, default }
        end

      end
    end

  end
end
