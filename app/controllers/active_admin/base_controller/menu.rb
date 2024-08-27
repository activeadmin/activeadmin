# frozen_string_literal: true
module ActiveAdmin
  class BaseController < ::InheritedResources::Base
    module Menu
      extend ActiveSupport::Concern

      included do
        before_action :set_current_menu_item

        helper_method :current_menu
        helper_method :current_menu_item?
      end

      protected

      def current_menu
        active_admin_config.navigation_menu
      end

      def current_menu_item?(item)
        item.current?(@current_menu_item)
      end

      def set_current_menu_item
        @current_menu_item = if current_menu && active_admin_config.belongs_to? && parent?
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
