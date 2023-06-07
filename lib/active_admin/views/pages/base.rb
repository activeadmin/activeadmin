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
              stylesheet_tag = active_admin_namespace.use_webpacker ? stylesheet_pack_tag(style, **options) : stylesheet_link_tag(style, **options)
              text_node(stylesheet_tag.html_safe) if stylesheet_tag
            end

            active_admin_namespace.meta_tags.each do |name, content|
              text_node(meta(name: name, content: content))
            end

            active_admin_application.javascripts.each do |path|
              javascript_tag = active_admin_namespace.use_webpacker ? javascript_pack_tag(path) : javascript_include_tag(path)
              text_node(javascript_tag)
            end

            if active_admin_namespace.favicon
              favicon = active_admin_namespace.favicon
              favicon_tag = active_admin_namespace.use_webpacker ? favicon_pack_tag(favicon) : favicon_link_tag(favicon)
              text_node(favicon_tag)
            end

            text_node csrf_meta_tag
          end
        end

        def build_page
          within body(class: body_classes) do
            div id: "wrapper" do
              build_unsupported_browser
              header active_admin_namespace, current_menu
              title_bar title, action_items_for_action
              build_page_content
              footer active_admin_namespace
            end
          end
        end

        def body_classes
          Arbre::HTML::ClassList.new [
            params[:action],
            params[:controller].tr("/", "_"),
            "active_admin", "logged_in",
            active_admin_namespace.name.to_s + "_namespace"
          ]
        end

        def build_unsupported_browser
          if active_admin_namespace.unsupported_browser_matcher =~ controller.request.user_agent
            unsupported_browser
          end
        end

        def build_page_content
          build_flash_messages
          div id: "active_admin_content", class: (skip_sidebar? ? "without_sidebar" : "with_sidebar") do
            build_main_content_wrapper
            sidebar sidebar_sections_for_action, id: "sidebar" unless skip_sidebar?
          end
        end

        def build_flash_messages
          div class: "flashes" do
            flash_messages.each do |type, messages|
              [*messages].each do |message|
                div message, class: "flash flash_#{type}"
              end
            end
          end
        end

        def build_main_content_wrapper
          div id: "main_content_wrapper" do
            div id: "main_content" do
              main_content
            end
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
