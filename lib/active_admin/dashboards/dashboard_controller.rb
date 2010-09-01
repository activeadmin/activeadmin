module ActiveAdmin
  module Dashboards
    class DashboardController < ResourceController

      # Render from here if not overriden
      self.default_views = 'active_admin_dashboard'

      clear_action_items!

      def index
        skip_sidebar!
        @dashboard_sections = find_sections
        render_or_default 'index'
      end

      protected

      def set_current_tab
        @current_tab = "Dashboard"
      end

      def find_sections
        ActiveAdmin::Dashboards.sections_for_namespace(namespace)
      end

      def namespace
        self.class.name.split('::').first.underscore.to_sym
      end

      # Return the current menu for the view. This is a helper method
      def current_menu
        ActiveAdmin.namespaces[namespace].menu
      end

      # Override to do nothing
      def add_section_breadcrumb
      end
    end
  end
end
