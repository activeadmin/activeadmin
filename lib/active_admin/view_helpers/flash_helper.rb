module ActiveAdmin
  module ViewHelpers
    module FlashHelper

      # Returns all the flash keys to display in any Active Admin view.
      # This method removes the :timedout key that Devise uses by default
      def active_admin_flash_messages
        @active_admin_flash_messages ||= flash.to_hash.except(:timedout)
      end

    end
  end
end
