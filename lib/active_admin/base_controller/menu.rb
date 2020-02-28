module ActiveAdmin
  class BaseController < ::InheritedResources::Base
    module Menu
      extend ActiveSupport::Concern

      included do
        before_action :set_current_tab
        helper_method :current_menu
      end

      protected

      def current_menu
        active_admin_config.navigation_menu
      end

      # Set's @current_tab to be name of the tab to mark as current
      # Get's called through a before filter
      def set_current_tab
        @current_tab =
          if current_menu && active_admin_config.belongs_to? && parent?
            active_admin_config.belongs_to_config.targets.find(-> { active_admin_config }) do |target|
              parent.is_a?(target.resource_class) && current_menu.include?(target.menu_item)
            end.menu_item
          else
            active_admin_config.menu_item
          end
      end

    end
  end
end
