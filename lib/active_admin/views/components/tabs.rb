# frozen_string_literal: true
module ActiveAdmin
  module Views
    class Tabs < ActiveAdmin::Component
      builder_method :tabs

      def tab(title, options = {}, &block)
        title = title.to_s.titleize if title.is_a? Symbol
        @menu << build_menu_item(title, options, &block)
        @tabs_content << build_content_item(title, options, &block)
      end

      def build(attributes = {}, &block)
        super(attributes)
        @menu = nav(class: "tabs-nav", role: "tablist", "data-tabs-toggle": "#tabs-container-#{object_id}")
        @tabs_content = div(class: "tabs-content", id: "tabs-container-#{object_id}")
      end

      def build_menu_item(title, options, &block)
        fragment = options.fetch(:id, fragmentize(title))
        html_options = options.fetch(:html_options, {}).merge("data-tabs-target": "##{fragment}", role: "tab", "aria-controls": fragment)
        button html_options do
          title
        end
      end

      def build_content_item(title, options, &block)
        options = options.reverse_merge(id: fragmentize(title), class: "hidden", role: "tabpanel", "aria-labelledby": "#{title}-tab")
        div(options, &block)
      end

      protected

      def default_class_name
        "tabs"
      end

      private

      def fragmentize(string)
        "tabs-#{string.parameterize}-#{object_id}"
      end
    end
  end
end
