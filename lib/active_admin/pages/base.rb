module ActiveAdmin
  module Pages
    class Base < ::ActiveAdmin::Renderer

      autoload :Header, 'active_admin/pages/base/header'

      # Returns the redenderer to use for the header on each page
      def header_renderer
        ActiveAdmin::Pages::Base::Header
      end

      def header
        content_for :header do
          header_renderer.new(self).to_html
        end
      end

      def breadcrumb(separator = "/")
        links = breadcrumb_links
        return if links.empty?
        sep = content_tag(:span, separator, :class => "breadcrumb_sep")
        content_tag :span, :class => "breadcrumb" do
          links.join(" #{sep} ") + sep
        end
      end

      def main_content
        "Please implement #{self.class.name}#main_content to display content.".html_safe
      end

      def title_bar
        content_for :title_bar do
          [breadcrumb, title_tag, action_items].join.html_safe
        end
      end

      def title_tag
        content_tag :h2, title, :id => 'page_title'
      end

      def title
        self.class.name
      end

      # Set's the page title for the layout to render
      def set_page_title
        set_ivar_on_view "@page_title", title
      end

      def action_items_renderer
        ActiveAdmin::ActionItems::Renderer
      end

      def action_items
        items = controller.class.action_items_for(params[:action])
        action_items_renderer.new(self).to_html(items)
      end

      # Returns the renderer class to use to render the sidebar
      #
      # You could override this method and return your own custom
      # sidebar renderer
      def sidebar_renderer
        ActiveAdmin::Sidebar::Renderer
      end

      # Returns the sidebar sections to render for the current action
      def sidebar_sections
        controller.class.sidebar_sections_for(params[:action])
      end

      # Renders the sidebar
      def sidebar
        content_for :sidebar do
          sidebar_renderer.new(self).to_html(sidebar_sections)
        end
      end

      # Renders the content for the footer
      def footer
        content_for :footer do
          content_tag :p, "Powered by #{link_to("Active Admin", "http://www.activeadmin.info")} #{ActiveAdmin::VERSION}".html_safe
        end
      end

      def to_html
        set_page_title
        header
        title_bar
        footer
        sidebar
        main_content
      end
    end
  end
end
