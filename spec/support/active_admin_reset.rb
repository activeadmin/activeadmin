# frozen_string_literal: true

# Resets Active Admin after every example, so each one starts with the test
# app as it booted. Specs don't need to clean up registrations themselves.
#
# Two things carry over between examples otherwise:
#
# 1. Resources registered in ActiveAdmin.application. Specs that call
#    ActiveAdmin.register without unloading leave them registered, with
#    their controllers and routes.
# 2. Controller classes from namespaces outside ActiveAdmin.application.
#    Registering creates a real constant, such as Admin::PostsController,
#    which Active Admin only removes when that namespace is unloaded. Many
#    specs register in a throwaway ActiveAdmin::Application or Namespace, or
#    remove a namespace from ActiveAdmin.application without unloading it.
#
# Active Admin reopens an existing controller class instead of creating a
# new one, so either kind of leftover carries its configuration (e.g.
# `belongs_to`) into later examples that register the same resource.
#
# After each example, and after its own cleanup:
#
# 1. Every namespace outside ActiveAdmin.application that registered
#    something during the example is unloaded with Namespace#unload!.
# 2. ActiveAdmin.application is reset to how it booted if its namespaces or
#    registrations changed, or if one of those namespaces shared a
#    controller class with it (a throwaway :admin namespace registering
#    "Dashboard", say). Unloading that namespace removes the shared class,
#    and it may have been changed, so the reset loads the app's own admin
#    files again, which creates fresh controller classes. Any namespace
#    added since boot is unloaded and removed first.
#
# Only Active Admin's own unloading is used, the same as when code reloads
# in development.
module ActiveAdminReset
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
    end

    def reset
      shared_controllers = unload_other_namespaces
      reset_application if shared_controllers || current_state != booted_state
    end

    private

    # The app's namespaces and the controller of each resource and page
    # registered in them.
    def current_state
      ActiveAdmin.application.namespaces.to_h do |namespace|
        [namespace.name, namespace.resources.map(&:controller_name).sort]
      end
    end

    def reset_application
      application = ActiveAdmin.application
      store = application.namespaces.instance_variable_get(:@namespaces)

      (application.namespaces.names - booted_state.keys).each do |name|
        store.delete(name).unload!
      end

      ActiveAdmin.unload!
      # Reloading routes calls ActiveAdmin.routes, which loads the app's own
      # admin files again.
      Rails.application.reload_routes!
      application.namespaces.each(&:reset_menu!)
    end

    # Unloads every namespace outside the app that registered something.
    # Returns whether any of them shared a controller class with the app:
    # unloading removes controller constants by name, so it removed the
    # app's controller too.
    def unload_other_namespaces
      app_namespaces = ActiveAdmin.application.namespaces.to_a
      registered = app_namespaces.flat_map { |namespace| namespace.resources.map(&:controller_name) }
      shared_controllers = false

      registering_namespaces.each do |namespace|
        next if app_namespaces.any? { |app_namespace| app_namespace.equal?(namespace) }

        shared_controllers ||= namespace.resources.map(&:controller_name).intersect?(registered)
        namespace.unload!
      end

      registering_namespaces.clear
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
