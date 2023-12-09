# frozen_string_literal: true
module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document

        def build(*args)
          set_attribute :lang, I18n.locale
          build_active_admin_head
          build_page
        end

        def title
          self.class.name
        end

        def main_content
          I18n.t("active_admin.main_content", model: title).html_safe
        end

        private

        delegate :active_admin_config, :controller, :params, to: :helpers

        def build_active_admin_head
          within head do
            render "active_admin/html_head/title", title: [title, helpers.active_admin_namespace.site_title(self)].compact.join(" - ")
            render "active_admin/head"
          end
        end

        def build_page
          within body(data_attributes) do
            div id: "wrapper" do
              header active_admin_namespace, current_menu
              title_bar title, action_items_for_action
              build_page_content
              render "active_admin/site_footer"
            end
          end
        end

        def data_attributes
          {
            "data-rails-action": params[:action],
            "data-rails-controller": params[:controller].tr("/", "_"),
            "data-active-admin-namespace": active_admin_namespace.name.to_s,
            "data-active-admin-logged-in": ""
          }
        end

        def build_page_content
          build_flash_messages
          div class: "page-content-container" do
            build_main_content_wrapper
            render "active_admin/base_page/sidebar", sections: sidebar_sections_for_action
          end
        end

        def build_flash_messages
          render partial: "active_admin/flash_messages"
        end

        def build_main_content_wrapper
          div class: "main-content-container" do
            main_content
          end
        end

        # Returns the sidebar sections to render for the current action
        def sidebar_sections_for_action
          if active_admin_config && active_admin_config.sidebar_sections?
            active_admin_config.sidebar_sections_for(params[:action], self)
          else
            []
          end
        end

        def action_items_for_action
          if active_admin_config && active_admin_config.action_items?
            active_admin_config.action_items_for(params[:action], self)
          else
            []
          end
        end

      end
    end
  end
end
