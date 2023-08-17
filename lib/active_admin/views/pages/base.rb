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

        alias_method :html_title, :title # Arbre::HTML::Title
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
            html_title [title, helpers.active_admin_namespace.site_title(self)].compact.join(" | ")

            text_node(active_admin_namespace.head)

            active_admin_application.stylesheets.each do |style, options|
              stylesheet_tag = stylesheet_link_tag(style, **options)
              text_node(stylesheet_tag.html_safe) if stylesheet_tag
            end

            active_admin_namespace.meta_tags.each do |name, content|
              text_node(meta(name: name, content: content))
            end

            active_admin_application.javascripts.each do |path, options|
              javascript_tag = javascript_include_tag(path, **options)
              text_node(javascript_tag)
            end

            if active_admin_namespace.favicon
              favicon = active_admin_namespace.favicon
              favicon_tag = favicon_link_tag(favicon)
              text_node(favicon_tag)
            end

            text_node csrf_meta_tags
            text_node csp_meta_tag
          end
        end

        def build_page
          within body(data_attributes) do
            div id: "wrapper" do
              header active_admin_namespace, current_menu
              title_bar title, action_items_for_action
              build_page_content
              footer active_admin_namespace
            end
          end
        end

        def data_attributes
          {
            "data-rails-action": params[:action],
            "data-rails-controller": params[:controller].tr("/", "_"),
            "data-active-admin-namespace": active_admin_namespace.name.to_s,
            "data-active-admin-logged-in": "true"
          }
        end

        def build_page_content
          build_flash_messages
          div class: "page-content-container" do
            build_main_content_wrapper
            sidebar sidebar_sections_for_action, id: "sidebar" unless skip_sidebar?
          end
        end

        def build_flash_messages
          div class: "flashes" do
            flash_messages.each do |type, messages|
              [*messages].each do |message|
                div class: "flash flash_#{type}" do
                  if type == "notice"
                    text_node '<svg class="flash-icon" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20"><path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/></svg>'.html_safe
                  elsif type == "alert"
                    text_node '<svg class="flash-icon" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20"><path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM10 15a1 1 0 1 1 0-2 1 1 0 0 1 0 2Zm1-4a1 1 0 0 1-2 0V6a1 1 0 0 1 2 0v5Z"/></svg>'.html_safe
                  end
                  text_node message
                end
              end
            end
          end
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

        def skip_sidebar?
          sidebar_sections_for_action.empty? || assigns[:skip_sidebar] == true
        end

      end
    end
  end
end
