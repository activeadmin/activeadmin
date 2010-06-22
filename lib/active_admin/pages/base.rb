module ActiveAdmin
  module Pages
    class Base < ::ActiveAdmin::Renderer

      def breadcrumb(separator = "&rsaquo;")
        @breadcrumbs.map { |txt, path| link_to_unless((path.blank? || current_page?(path)), h(txt), path) }.join(" #{separator} ")
      end

      def main_content
        "Please implement #{self.class.name}#main_content to display content.".html_safe
      end

      def title_bar
        content_tag :div, [breadcrumb, title_tag, action_items].join.html_safe, :id => 'title_bar'
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

      def to_html
        set_page_title
        title_bar +
          main_content +
          sidebar
      end
    end
  end
end
