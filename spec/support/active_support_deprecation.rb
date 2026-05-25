# frozen_string_literal: true

# Module to help with deprecation warnings in specs.
module ActiveAdmin
  # A good name for this module would be ActiveAdmin::ActiveSupport::Deprecation, but
  # that would require a lot of changes in the codebase because, for example, there are references to
  # ActiveSupport::Notification in ActiveAdmin module without the :: prefix.
  # So, we are using ActiveAdmin::DeprecationHelper instead.
  module DeprecationHelper
    def self.behavior=(value)
      Rails.application.deprecators.behavior = :raise
    end
  end
end
