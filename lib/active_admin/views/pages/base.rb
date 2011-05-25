module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document

        def build(*args)
          super
          add_classes_to_body
          build_active_admin_head
          build_page
        end

        private


        def add_classes_to_body
          @body.add_class(params[:action])
          @body.add_class(params[:controller].gsub('/', '_'))
        end

        def build_active_admin_head
          within @head do
            meta :"http-equiv" => "Content-type", :content => "text/html; charset=utf-8"
            insert_tag Arbre::HTML::Title, [title, ActiveAdmin.site_title].join(" | ")
            ActiveAdmin.stylesheets.each do |path|
              link :href => stylesheet_path(path), :media => "screen", :rel => "stylesheet", :type => "text/css"
            end
            ActiveAdmin.javascripts.each do |path|
              script :src => javascript_path(path), :type => "text/javascript"
            end
            text_node csrf_meta_tag
          end
        end

        def build_page
          within @body do
            div :id => "wrapper" do
              build_header
              build_title_bar
              build_page_content
              build_footer
            end
          end
        end

        def build_header
          div :id => "header" do
            render view_factory.header
          end
        end

        def build_title_bar
          div :id => "title_bar" do
            build_breadcrumb
            build_title_tag
            build_action_items
          end
        end

        def build_breadcrumb(separator = "/")
          links = breadcrumb_links
          return if links.empty?
          span :class => "breadcrumb" do
            links.each do |link|
              text_node link
              span(separator, :class => "breadcrumb_sep")
            end
          end
        end

        def build_title_tag
          h2(title, :id => 'page_title')
        end

        def build_action_items
          items = controller.class.action_items_for(params[:action])
          insert_tag view_factory.action_items, items
        end

        def build_page_content
          div :id => "active_admin_content", :class => (skip_sidebar? ? "without_sidebar" : "with_sidebar") do
            build_flash_messages
            build_main_content_wrapper
            build_sidebar
          end
        end

        def build_flash_messages
          if flash.keys.any?
            div :class => 'flashes' do
              flash.each do |type, message|
                div message, :class => "flash flash_#{type}"
              end
            end
          end
        end

        def build_main_content_wrapper
          div :id => "main_content_wrapper" do
            div :id => "main_content" do
              main_content
            end
          end
        end

        def main_content
          "Please implement #{self.class.name}#main_content to display content.".html_safe
        end

        def title
          self.class.name
        end

        # Set's the page title for the layout to render
        def set_page_title
          set_ivar_on_view "@page_title", title
        end


        # Returns the sidebar sections to render for the current action
        def sidebar_sections_for_action
          controller.class.sidebar_sections_for(params[:action])
        end

        # Renders the sidebar
        def build_sidebar
          div :id => "sidebar" do
            sidebar_sections_for_action.collect do |section|
              sidebar_section(section)
            end
          end
        end

        # Renders the content for the footer
        def build_footer
          div :id => "footer" do
            para "Powered by #{link_to("Active Admin", "http://www.activeadmin.info")} #{ActiveAdmin::VERSION}".html_safe
          end
        end

      end
    end
  end
end
