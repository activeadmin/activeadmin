module ActiveAdmin
  class BaseController < ::InheritedResources::Base
    module Menu
      extend ActiveSupport::Concern

      included do
        if ActiveAdmin::Dependency.rails >= 4
          before_action :set_current_tab
        else
          before_filter :set_current_tab
        end
        helper_method :current_menu
      end

      protected

      def current_menu
        active_admin_config.navigation_menu
      end

      # Set's @current_tab to be name of the tab to mark as current
      # Get's called through a before filter
      def set_current_tab
        @current_tab = if current_menu && active_admin_config.belongs_to? && parent?
          parent_item = active_admin_config.belongs_to_config.target.menu_item
          if current_menu.include? parent_item
            parent_item
          else
            active_admin_config.menu_item
          end
        else
          active_admin_config.menu_item
        end
      end

    end
  end
end
