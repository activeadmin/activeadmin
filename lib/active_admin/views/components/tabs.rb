module ActiveAdmin
  module Views
    class Tabs < ActiveAdmin::Component
      builder_method :tabs

      def tab(title, options = {}, &block)
        title = title.to_s.titleize if title.is_a? Symbol
        @menu << build_menu_item(title, options, &block)
        @tabs_content << build_content_item(title, options, &block)
      end

      def build(&block)
        @menu = ul(class: 'nav nav-tabs', role: "tablist")
        @tabs_content = div(class: 'tab-content')
      end

      def build_menu_item(title, options, &block)
        fragment = options.fetch(:id, title.parameterize)
        li { link_to title, "##{fragment}" }
      end

      def build_content_item(title, options, &block)
        options = options.reverse_merge(id: title.parameterize)
        div(options, &block)
      end
    end
  end
end
