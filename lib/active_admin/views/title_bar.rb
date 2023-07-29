# frozen_string_literal: true
module ActiveAdmin
  module Views
    class TitleBar < Component

      def build(title, action_items)
        super(class: "page-title-bar")
        @title = title
        @action_items = action_items
        build_titlebar_left
        build_titlebar_right
      end

      private

      def build_titlebar_left
        div class: "page-title-bar-content" do
          build_breadcrumb
          build_title_tag
        end
      end

      def build_titlebar_right
        div class: "page-title-bar-actions" do
          build_action_items
        end
      end

      def build_breadcrumb
        breadcrumb_config = active_admin_config && active_admin_config.breadcrumb

        links = if breadcrumb_config.is_a?(Proc)
                  instance_exec(controller, &active_admin_config.breadcrumb)
                elsif breadcrumb_config.present?
                  breadcrumb_links
                end
        return unless links.present? && links.is_a?(::Array)
        nav "aria-label": "breadcrumb" do
          ol class: "breadcrumbs" do
            links.each do |link|
              li class: "breadcrumbs-item" do
                text_node link
              end
            end
          end
        end
      end

      def build_title_tag
        h2(@title, class: "page-title-bar-heading")
      end

      def build_action_items
        @action_items.each do |action_item|
          text_node instance_exec(&action_item.block)
        end
      end

    end
  end
end
