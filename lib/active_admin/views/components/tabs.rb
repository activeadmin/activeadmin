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
        fragment = title.gsub(/[[:space:]]/, "") if fragment.blank?
        raise "The tab title is not transliterable into an ascii only id that can be used as a url fragment for this tab. Either manually specify a tab id, or add the proper transliteration rules to your application." if fragment.blank?
        html_options = options.fetch(:html_options, {})
        li html_options do
          link_to title, "##{fragment}"
        end
      end

      def build_content_item(title, options, &block)
        options = options.reverse_merge(id: title.parameterize)
        div(options, &block)
      end
    end
  end
end
