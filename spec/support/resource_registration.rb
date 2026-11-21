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
# The registrations are cleared after the example, so they don't carry into
# later specs in the same worker.
module ResourceRegistrationHelper
  def register_resources(&block)
    @registered_resources = true
    load_resources(&block)
  end
end

RSpec.configure do |config|
  config.include ResourceRegistrationHelper, type: :request
  config.include ResourceRegistrationHelper, type: :system

  config.after do
    load_resources {} if @registered_resources
  end
end
