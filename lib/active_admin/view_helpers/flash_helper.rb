# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module FlashHelper

      # Returns all the flash keys to display in any Active Admin view.
      # This method removes the :timedout key that Devise uses by default.
      # Note Rails >= 4.1 normalizes keys to strings automatically.
      def flash_messages
        @flash_messages ||= flash.to_hash.with_indifferent_access.except(*active_admin_application.flash_keys_to_except)
      end

    end
  end
end
