module ActiveAdmin
  module Pages

    class BaseRenderer < ::ActiveAdmin::Renderer

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

      def action_items_tag
        content_tag :div, action_items, :id => "action_items"
      end

      def action_items
      end

      def sidebar
        content_for :sidebar do
          render_partial_or_default 'sidebar'
        end
      end

      def to_html
        title_bar +
          main_content +
          sidebar
      end
    end

    class Index < BaseRenderer
      def title
        resources_name
      end

      def main_content
        index_config.render(self, collection)
      end

      def action_items
        link_to "New #{resource_name}", new_resource_path
      end
    end

    class New < BaseRenderer
    end

    class Edit < BaseRenderer
    end

    class Show < BaseRenderer
    end

  end
end
