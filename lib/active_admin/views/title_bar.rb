module ActiveAdmin
  module Views
    class TitleBar < Component

      def build(title, action_items)
        super(:id => "title_bar", :class => "container-fluid")
        @title = title
        @action_items = action_items

        div :class => "row-fluid" do
          build_titlebar_left
          build_titlebar_right
        end
      end

      private

      def build_titlebar_left
        div :id => "titlebar_left" do
          build_breadcrumb
          build_title_tag
        end
      end

      def build_titlebar_right
        div :id => "titlebar_right" do
          build_action_items
        end
      end

      def build_breadcrumb(separator = "/")
        links = if active_admin_config && active_admin_config.breadcrumb.present?
          instance_exec(controller, &active_admin_config.breadcrumb)
        else
          breadcrumb_links
        end
        return unless links.present? && links.is_a?(::Array)
        ul :class => "breadcrumb" do
          links.each do |link|
            li do
              text_node link
              span(separator, :class => "divider")
            end
          end
        end
      end

      def build_title_tag
        h2(@title, :id => 'page_title')
      end

      def build_action_items
        insert_tag(view_factory.action_items, @action_items) if @action_items.any?
      end

    end
  end
end
