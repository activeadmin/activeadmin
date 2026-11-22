# frozen_string_literal: true

# Registers Active Admin resources for the current example.
#
#   register_resources do
#     ActiveAdmin.register(Post) { index title: "Posts" }
#   end
#
# Use it when each example needs a different configuration. When every
# example in a group shares one, `with_resources_during` in an `around`
# block does the same job.
#
# It unloads the app's registrations, runs the block, and reloads menus and
# routes. Reloading routes also loads the test app's own app/admin files, so
# they're registered alongside the block's. Nothing needs undoing afterwards:
# spec/support/active_admin_reset.rb resets Active Admin to its booted state
# after every example, including namespaces the block added and menu items
# added with build_menu.
module ResourceRegistrationHelper
  def register_resources
    ActiveAdmin.unload!
    yield
    ActiveAdmin.application.namespaces.each(&:reset_menu!)
    Rails.application.reload_routes!
  end

  # Keeps registration in the around hook before the example runs.
  # ActiveAdminReset restores the application after all example cleanup.
  def with_resources_during(example)
    register_resources { yield }

    example.run
  end

  # Loads the test app's own app/admin files (dashboard, admin users,
  # companies, stores, profiles) for the current example, plus anything the
  # block registers. Use it when a spec relies on those, e.g. the dashboard
  # at admin_root_path, and doesn't register anything itself.
  #
  # Every example starts with them loaded, routes included (see
  # spec/support/active_admin_reset.rb), so this mainly makes a spec's
  # dependence on them explicit.
  def load_default_resources
    register_resources do
      ActiveAdmin.application.load!
      yield if block_given?
    end
  end
end

RSpec.configure do |config|
  config.include ResourceRegistrationHelper
end
