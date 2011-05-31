module ActiveAdmin
  module Dashboards
    class DashboardController < ResourceController

      before_filter :skip_sidebar!

      actions :index

      clear_action_items!

      def index
        @dashboard_sections = find_sections
      end

      protected

      # Override _prefix so we force ActionController to render
      # the views from active_admin/dashboard instead of default path.
      def _prefix
        'active_admin/dashboard'
      end

      def set_current_tab
        @current_tab = "Dashboard"
      end

      def find_sections
        ActiveAdmin::Dashboards.sections_for_namespace(namespace)
      end

      def namespace
        class_name = self.class.name
        if class_name.include?('::')
          self.class.name.split('::').first.underscore.to_sym
        else
          :root
        end
      end

      # Return the current menu for the view. This is a helper method
      def current_menu
        ActiveAdmin.namespaces[namespace].menu
      end

    end
  end
end
