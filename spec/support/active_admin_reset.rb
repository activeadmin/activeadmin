# frozen_string_literal: true

# Resets Active Admin after every example, so each one starts with the test
# app as it booted. Specs don't need to clean up registrations themselves.
#
# Four things carry over between examples otherwise:
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
# 4. Routes drawn for a different application. Some specs swap
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
# 2. ActiveAdmin.application is reset to how it booted if a resource or page
#    was registered, or its namespaces, menu build callbacks or routes changed.
#    It also resets if another namespace shared a controller class with it
#    (a throwaway :admin namespace registering "Dashboard", say). Unloading it
#    removes the shared class, and it may have been changed, so the reset
#    loads the app's own admin files again, which creates fresh controller
#    classes. Any namespace added since boot is unloaded and removed first,
#    and each namespace's menu build callbacks are restored.
# 3. If a namespace outside the app shared a controller class with it, the
#    example fails, after the cleanup above, so the next example still
#    starts clean. While they share a class, whatever the spec configures
#    on one also changes the other, which makes the spec's results depend
#    on the app's registrations. The message names the controller, so the
#    spec can register under a different namespace or resource name.
#
# Only Active Admin's own unloading is used, the same as when code reloads
# in development.
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

  # Records every namespace that registers a resource or page.
  module RecordRegistrations
    def register(...)
      ActiveAdminReset.registering_namespaces << self
      super
    end

    def register_page(...)
      ActiveAdminReset.registering_namespaces << self
      super
    end
  end

  class << self
    attr_reader :booted_state

    def registering_namespaces
      @registering_namespaces ||= Set.new.compare_by_identity
    end

    def record_booted_state
      @booted_state = current_state
      @booted_menu_callbacks = menu_build_callbacks.transform_values(&:dup)
      @booted_route_names = route_names
      registering_namespaces.clear
    end

    def reset
      app_namespaces = ActiveAdmin.application.namespaces.to_a
      app_registered = registering_namespaces.any? do |namespace|
        app_namespaces.any? { |app_namespace| app_namespace.equal?(namespace) }
      end
      shared_controllers = unload_other_namespaces
      reset_application if app_registered || shared_controllers.any? || changed_since_boot?
      raise SharedControllerError, shared_controllers if shared_controllers.any?
    ensure
      # Registrations made by cleanup belong to the restored app, not the
      # next example.
      registering_namespaces.clear
    end

    private

    # The app's namespaces and the controller of each resource and page
    # registered in them.
    def current_state
      ActiveAdmin.application.namespaces.to_h do |namespace|
        [namespace.name, namespace.resources.map(&:controller_name).sort]
      end
    end

    # The callbacks each namespace's menu runs when it's built, which is where
    # build_menu adds its items. They have no public accessor.
    def menu_build_callbacks
      ActiveAdmin.application.namespaces.to_h do |namespace|
        [namespace.name, namespace.instance_variable_get(:@menus).instance_variable_get(:@build_callbacks)]
      end
    end

    def changed_since_boot?
      return true if current_state != booted_state
      return true if route_names != @booted_route_names

      menu_build_callbacks.any? do |name, callbacks|
        callbacks.map(&:object_id) != @booted_menu_callbacks.fetch(name).map(&:object_id)
      end
    end

    # Rails loads routes lazily, so this loads them first if needed.
    def route_names
      Rails.application.reload_routes_unless_loaded
      Rails.application.routes.named_routes.names.sort
    end

    def reset_application
      application = ActiveAdmin.application
      store = application.namespaces.instance_variable_get(:@namespaces)

      (application.namespaces.names - booted_state.keys).each do |name|
        store.delete(name).unload!
      end

      menu_build_callbacks.each do |name, callbacks|
        callbacks.replace(@booted_menu_callbacks.fetch(name))
      end

      ActiveAdmin.unload!
      # Reloading routes calls ActiveAdmin.routes, which loads the app's own
      # admin files again.
      Rails.application.reload_routes!
      application.namespaces.each(&:reset_menu!)
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
