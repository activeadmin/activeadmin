module ActiveAdmin
  module Views
    class Tabs < ActiveAdmin::Component
      builder_method :tabs

      def build(&block)
        @menu = ul(class: 'nav nav-tabs', role: "tablist")
        @tabs_content = div(class: 'tab-content')
      end

      private

      def tab(title, options = {}, &block)
        title = title.to_s.titleize if title.is_a? Symbol
        id    = options.delete(:id) { title.parameterize }
        @menu << build_menu_item(title, options.merge(ancor: id), &block)
        @tabs_content << build_content_item(title, options.merge(id: id), &block)
      end

      def build_menu_item(title, options, &block)
        li { link_to title, options }
      end

      def build_content_item(title, options, &block)
        div(options, &block)
      end
    end
  end
end
