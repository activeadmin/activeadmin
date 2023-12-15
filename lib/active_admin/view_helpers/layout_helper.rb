# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module LayoutHelper
      def set_page_title(title)
        @page_title = title
      end

      def site_title
        active_admin_application.site_title(self)
      end

      def html_head_site_title(separator: "-")
        "#{@page_title || page_title} #{separator} #{site_title}"
      end

      def action_items_for_action
        @action_items_for_action ||= begin
          if active_admin_config && active_admin_config.action_items?
            active_admin_config.action_items_for(params[:action], self)
          else
            []
          end
        end
      end

      def sidebar_sections_for_action
        @sidebar_sections_for_action ||= begin
          if active_admin_config && active_admin_config.sidebar_sections?
            active_admin_config.sidebar_sections_for(params[:action], self)
          else
            []
          end
        end
      end
    end
  end
end
