# frozen_string_literal: true

# Resets Active Admin after every example, so each one starts with the test
# app as it booted. Specs don't need to clean up registrations themselves.
#
# Five things carry over between examples otherwise:
#
# 1. Resources registered in ActiveAdmin.application. Specs that call
#    ActiveAdmin.register without unloading leave them registered, with
#    their controllers and routes. Namespaces they add stay registered too,
#    and unloading resources doesn't remove them.
# 2. Controller classes from namespaces outside ActiveAdmin.application.
#    Registering creates a real constant, such as Admin::PostsController,
#    which Active Admin only removes when that namespace is unloaded. Many
#    specs register in a throwaway ActiveAdmin::Application or Namespace, or
#    remove a namespace from ActiveAdmin.application without unloading it.
# 3. Menu items added with Namespace#build_menu. It adds a callback that
#    runs every time the menu is built, which survives menu resets.
# 4. Namespace modules created for temporary namespaces, including those in
#    another application, survive after the namespace is unloaded.
# 5. Routes drawn for a different application. Some specs swap
#    ActiveAdmin.application for a temporary one (default_namespace_spec)
#    and put it back without reloading routes.
#
# Active Admin reopens an existing controller class instead of creating a
# new one, so a leftover controller class carries its configuration (e.g.
# `belongs_to`) into later examples that register the same resource.
#
# After each example, and after its own cleanup:
#
# 1. Every namespace outside ActiveAdmin.application that registered
#    something during the example is unloaded with Namespace#unload!.
# 2. Application and namespace settings are restored to their booted values.
# 3. The boot namespaces are restored, ActiveAdmin.application is unloaded,
#    and its admin files are loaded again. This restores resource configuration,
#    route definitions, menu callbacks, and controller classes, including
#    changes that keep their names.
# 4. Modules created for temporary namespaces are removed, while modules
#    that existed before the example are left alone.
# 5. If an external namespace shared a controller class with the app, the
#    example fails after cleanup. While they share a class, configuration on
#    one also changes the other. The message names the controller, so the spec
#    can use a different namespace or resource name.
#
module ActiveAdminReset
  class SharedControllerError < StandardError
    def initialize(controllers)
      super(
        "A namespace outside ActiveAdmin.application registered #{controllers.join(', ')}, " \
        "which ActiveAdmin.application also had registered, so both used the same controller " \
        "class. Register it under a different namespace or resource name in the spec, e.g. " \
        "ActiveAdmin::Namespace.new(application, :test) instead of :admin."
      )
    end
  end

  # Tracks registrations and modules created by namespaces.
  module RecordRegistrations
    def register(...)
      ActiveAdminReset.registering_namespaces << self
      super
    end

    def register_page(...)
      ActiveAdminReset.registering_namespaces << self
      super
    end

    protected

    def register_module
      existed = Object.const_defined?(module_name)
      super
      ActiveAdminReset.created_namespace_modules[module_name] = Object.const_get(module_name, false) unless existed
    end
  end

  class << self
    def registering_namespaces
      @registering_namespaces ||= Set.new.compare_by_identity
    end

    def created_namespace_modules
      @created_namespace_modules ||= {}
    end

    def record_booted_state
      @booted_application = ActiveAdmin.application
      @booted_namespaces = @booted_application.namespaces.to_h { |namespace| [namespace.name, namespace] }
      @booted_menu_callbacks = menu_build_callbacks.transform_values(&:dup)
      @booted_settings = settings_nodes.to_h do |settings|
        [settings, settings_snapshot(settings)]
      end
      registering_namespaces.clear
      created_namespace_modules.clear
    end

    def reset
      ActiveAdmin.application = @booted_application
      shared_controllers = unload_other_namespaces
      restore_settings
      reset_application
      remove_created_namespace_modules
      raise SharedControllerError, shared_controllers if shared_controllers.any?
    ensure
      # Registrations made by cleanup belong to the restored app, not the
      # next example.
      registering_namespaces.clear
      created_namespace_modules.clear
    end

    private

    # The callbacks each namespace's menu runs when it's built, which is where
    # build_menu adds its items. MenuCollection has no public accessor for
    # @build_callbacks, so this snapshot depends on its private storage.
    # If that storage changes, update this helper and its reset specs together.
    def menu_build_callbacks
      ActiveAdmin.application.namespaces.to_h do |namespace|
        [namespace.name, namespace.instance_variable_get(:@menus).instance_variable_get(:@build_callbacks)]
      end
    end

    def settings_nodes
      application = @booted_application
      [
        ActiveAdmin::ApplicationSettings,
        ActiveAdmin::NamespaceSettings,
        application.settings,
        application.namespace_settings,
        *application.namespaces.map(&:settings)
      ]
    end

    def settings_snapshot(settings)
      setting_names = settings.ancestors
        .take_while { |ancestor| ancestor.is_a?(Class) && ancestor <= ActiveAdmin::SettingsNode }
        .flat_map { |ancestor| ancestor.singleton_class.instance_methods(false) }
        .filter_map do |method|
          name = method.to_s.delete_suffix("=") if method.to_s.end_with?("=")
          name unless name.nil? || name.end_with?("_setting")
        end.uniq

      values = setting_names.to_h do |name|
        attribute = settings.respond_to?("#{name}_setting") ? "#{name}_setting" : name
        [attribute, duplicate_setting(settings.public_send(attribute))]
      end

      methods = local_setting_methods(settings)
      method_definitions = setting_names.filter_map do |name|
        writer = :"#{name}="
        next unless settings.respond_to?("#{name}_setting") && methods.include?(writer)

        [writer, settings.singleton_class.instance_method(writer)]
      end.to_h
      { values: values, methods: methods,
        method_definitions: method_definitions,
        instance_methods: local_instance_methods(settings) }
    end

    def restore_settings
      @booted_settings.each do |settings, snapshot|
        snapshot[:values].each do |name, value|
          settings.public_send("#{name}=", duplicate_setting(value))
        end

        (local_setting_methods(settings) - snapshot[:methods]).each do |method|
          settings.singleton_class.remove_method(method)
        end
        snapshot[:method_definitions].each do |method, definition|
          settings.singleton_class.define_method(method, definition)
        end
        (local_instance_methods(settings) - snapshot[:instance_methods]).each do |method|
          settings.remove_method(method)
        end
      end
    end

    def local_setting_methods(settings)
      settings.singleton_class.instance_methods(false) + settings.singleton_class.private_instance_methods(false)
    end

    def local_instance_methods(settings)
      settings.instance_methods(false) + settings.private_instance_methods(false)
    end

    def duplicate_setting(value)
      case value
      when String
        copy = value.dup
        value.frozen? ? copy.freeze : copy
      when Array
        copy = value.map { |item| duplicate_setting(item) }
        value.frozen? ? copy.freeze : copy
      when Hash
        copy = value.dup
        value.each { |key, item| copy[duplicate_setting(key)] = duplicate_setting(item) }
        value.frozen? ? copy.freeze : copy
      when ActiveAdmin::DynamicSetting
        value.dup.tap do |copy|
          copy.instance_variable_set(:@setting, duplicate_setting(value.instance_variable_get(:@setting)))
        end
      else
        value
      end
    end

    def reset_application
      application = ActiveAdmin.application
      # Namespaces has no public method to restore its members. Keep the booted
      # objects so settings snapshots still refer to the registered namespaces.
      # If @namespaces changes, update this helper and its reset specs together.
      store = application.namespaces.instance_variable_get(:@namespaces)

      store.each do |name, namespace|
        namespace.unload! unless namespace.equal?(@booted_namespaces[name])
      end
      store.replace(@booted_namespaces)

      menu_build_callbacks.each do |name, callbacks|
        callbacks.replace(@booted_menu_callbacks.fetch(name))
      end

      ActiveAdmin.unload!
      # Reloading routes calls ActiveAdmin.routes, which loads the app's own
      # admin files again.
      Rails.application.reload_routes!
      application.namespaces.each(&:reset_menu!)
    end

    def remove_created_namespace_modules
      created_namespace_modules.each do |name, namespace_module|
        if Object.const_defined?(name, false) && Object.const_get(name, false).equal?(namespace_module)
          Object.send(:remove_const, name)
        end
      end
    end

    # Unloads every namespace outside the app that registered something.
    # Returns the controllers any of them shared with the app: unloading
    # removes controller constants by name, so it removed the app's too.
    def unload_other_namespaces
      app_namespaces = ActiveAdmin.application.namespaces.to_a
      registered = app_namespaces.flat_map { |namespace| namespace.resources.map(&:controller_name) }
      shared_controllers = []

      registering_namespaces.each do |namespace|
        next if app_namespaces.any? { |app_namespace| app_namespace.equal?(namespace) }

        shared_controllers |= namespace.resources.map(&:controller_name) & registered
        # RSpec can remove a stub_const namespace module before this around
        # hook runs. Its resources cannot be unloaded after that module is gone.
        next if namespace.module_name && !Object.const_defined?(namespace.module_name, false)

        namespace.unload!
      end

      shared_controllers
    end
  end
end

ActiveAdmin::Namespace.prepend(ActiveAdminReset::RecordRegistrations)
ActiveAdminReset.record_booted_state

RSpec.configure do |config|
  # An around hook in the configuration wraps every other hook, so this runs
  # after the example's own cleanup (after hooks, with_resources_during).
  config.around do |example|
    example.run
  ensure
    ActiveAdminReset.reset
  end
end
