# frozen_string_literal: true
module ActiveAdmin
  class ResourceController < BaseController

    module ActionBuilder
      extend ActiveSupport::Concern

      module ClassMethods

        def clear_member_actions!
          remove_action_methods(:member)
          active_admin_config.clear_member_actions!
        end

        def clear_collection_actions!
          remove_action_methods(:collection)
          active_admin_config.clear_collection_actions!
        end

        private

        def remove_action_methods(actions_type)
          active_admin_config.public_send("#{actions_type}_actions").each do |action|
            remove_method action.name
          end
        end
      end

    end

  end
end
