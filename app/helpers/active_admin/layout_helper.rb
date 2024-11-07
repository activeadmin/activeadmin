# frozen_string_literal: true
module ActiveAdmin
  module LayoutHelper
    # Returns the current Active Admin application instance
    def active_admin_application
      ActiveAdmin.application
    end

    def set_page_title(title)
      @page_title = title
    end

    def site_title
      # Prioritize namespace and account for Devise views where namespace is not available
      namespace = active_admin_namespace if respond_to?(:active_admin_namespace)
      (namespace || active_admin_application).site_title(self)
    end

    def html_head_site_title(separator: "-")
      "#{@page_title || page_title} #{separator} #{site_title}"
    end

    def action_items_for_action
      @action_items_for_action ||= begin
        if active_admin_config&.action_items?
          active_admin_config.action_items_for(params[:action], self)
        else
          []
        end
      end
    end

    def sidebar_sections_for_action
      @sidebar_sections_for_action ||= begin
        if active_admin_config&.sidebar_sections?
          active_admin_config.sidebar_sections_for(params[:action], self)
        else
          []
        end
      end
    end

    def skip_sidebar!
      @skip_sidebar = true
    end

    def skip_sidebar?
      @skip_sidebar == true
    end

    def flash_messages
      @flash_messages ||= flash.to_hash.except(*active_admin_application.flash_keys_to_except)
    end

    def url_for_comments(*args)
      parts = []
      parts << active_admin_namespace.name unless active_admin_namespace.root?
      parts << active_admin_namespace.comments_registration_name.underscore
      parts << "path"
      send parts.join("_"), *args
    end
  end
end
