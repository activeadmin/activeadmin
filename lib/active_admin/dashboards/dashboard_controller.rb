module ActiveAdmin
  module Dashboards
    class DashboardController < ResourceController

      actions :index

      def index
        @dashboard_sections = find_sections
        render 'active_admin/dashboard/index.html.arb'
      end

      protected

      def set_current_tab
        @current_tab = I18n.t("active_admin.dashboard")
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
        ActiveAdmin.application.namespaces[namespace].menu
      end

    end
  end
end
