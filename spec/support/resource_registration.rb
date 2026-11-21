# frozen_string_literal: true

# Registers Active Admin resources for the current example only.
#
#   register_resources do
#     ActiveAdmin.register(Post) { index title: "Posts" }
#   end
#
# Use it when each example needs a different configuration. When every
# example in a group shares one, `with_resources_during` in an `around`
# block does the same job.
#
# After the example, the registrations are cleared and any namespace the
# block created (e.g. `ActiveAdmin.register Post, namespace: :superadmin`)
# is removed, and menu items the block added with `build_menu` are
# removed, so none of it carries into later specs in the same worker.
# Unloading resources doesn't undo either: namespaces stay registered (and
# their routes come back on reload), and build_menu callbacks survive
# menu resets.
module ResourceRegistrationHelper
  def register_resources(&block)
    @namespaces_before_registration ||= registered_namespace_names
    @menu_callbacks_before_registration ||= menu_build_callbacks.transform_values(&:dup)
    load_resources(&block)
  end

  # Loads the test app's own app/admin files (dashboard, admin users,
  # companies, stores, profiles) for the current example, plus anything the
  # block registers. Use it when a spec relies on those, e.g. the dashboard
  # at admin_root_path, and doesn't register anything itself.
  #
  # register_resources loads them as a side effect: reloading routes calls
  # ActiveAdmin.routes, which loads the app's admin files. A spec that
  # registers nothing mustn't rely on what earlier specs left behind, though.
  # Some (e.g. default_namespace_spec) swap ActiveAdmin.application and leave
  # routes from a different application. Cucumber reloaded the app's admin
  # files before every scenario; RSpec doesn't.
  def load_default_resources
    register_resources do
      ActiveAdmin.application.load!
      yield if block_given?
    end
  end

  private

  def registered_namespace_names
    ActiveAdmin.application.namespaces.names
  end

  # The callbacks each namespace's menu runs when it's built, which is where
  # build_menu adds its items.
  def menu_build_callbacks
    ActiveAdmin.application.namespaces.to_h do |namespace|
      [namespace.name, namespace.instance_variable_get(:@menus).instance_variable_get(:@build_callbacks)]
    end
  end

  def clear_registered_resources
    added = registered_namespace_names - @namespaces_before_registration
    namespaces = ActiveAdmin.application.namespaces.instance_variable_get(:@namespaces)
    added.each { |name| namespaces.delete(name) }

    menu_build_callbacks.each do |name, callbacks|
      callbacks.replace(@menu_callbacks_before_registration.fetch(name))
    end

    load_resources {}
  end
end

RSpec.configure do |config|
  config.include ResourceRegistrationHelper, type: :request
  config.include ResourceRegistrationHelper, type: :system

  config.after do
    clear_registered_resources if @namespaces_before_registration
  end
end
