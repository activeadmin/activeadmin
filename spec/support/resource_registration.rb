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
# is removed, so neither carries into later specs in the same worker.
# Namespaces have to be removed explicitly because unloading resources
# leaves them registered, and their routes would come back on reload.
module ResourceRegistrationHelper
  def register_resources(&block)
    @namespaces_before_registration ||= registered_namespace_names
    load_resources(&block)
  end

  private

  def registered_namespace_names
    ActiveAdmin.application.namespaces.names
  end

  def clear_registered_resources
    added = registered_namespace_names - @namespaces_before_registration
    namespaces = ActiveAdmin.application.namespaces.instance_variable_get(:@namespaces)
    added.each { |name| namespaces.delete(name) }

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
