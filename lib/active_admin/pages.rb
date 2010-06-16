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
          sidebar_renderer.new(self).render(sidebar_sections)
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

      # Render's the index configuration that was set in the
      # controller. Defaults to rendering the ActiveAdmin::TableBuilder::Renderer
      def main_content
        index_config.render(self, collection)
      end

      def action_items
        link_to "New #{resource_name}", new_resource_path
      end
    end

    class New < BaseRenderer
      def title
        "New #{resource_name}"
      end
      def main_content
        active_admin_form_for resource, :url => collection_path, &form_config
      end
    end

    class Edit < BaseRenderer
      def title
        "Edit #{resource_name}"
      end
      def main_content
        active_admin_form_for resource, :url => resource_path(resource), &form_config
      end
    end

    class Show < BaseRenderer
      def title
        "#{resource_name} ##{resource.id}"
      end
      def main_content
        content_tag :dl, :id => "#{resource_class.name.underscore}_attributes", :class => "resource_attributes" do
          show_view_columns.collect do |attr|
            content_tag(:dt, attr.to_s.titlecase) + content_tag(:dd, resource.send(attr))
          end.join
        end
      end
    end

  end
end
