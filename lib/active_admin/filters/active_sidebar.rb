# frozen_string_literal: true
require "active_admin/filters/active"

module ActiveAdmin
  module Filters
    class ActiveSidebar < ActiveAdmin::SidebarSection

      def initialize
        super "search_status", sidebar_options
      end

      def block
        -> { active_filters_sidebar_content }
      end

      def title
        I18n.t("active_admin.search_status.headline")
      end

      protected

      def sidebar_options
        { only: :index, if: -> { active_admin_config.current_filters_enabled? && (params[:q] || params[:scope]) } }
      end

    end
  end
end
