module ActiveAdmin
  class ResourceController < BaseController

    module ActionBuilder
      extend ActiveSupport::Concern

      module ClassMethods

        def clear_member_actions!
          active_admin_config.clear_member_actions!
        end

        def clear_collection_actions!
          active_admin_config.clear_collection_actions!
        end
      end

    end

  end
end
