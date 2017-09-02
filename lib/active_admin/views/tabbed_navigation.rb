module ActiveAdmin
  module Views

    # Renders an ActiveAdmin::Menu as a set of unordered list items.
    #
    # This component takes cares of deciding which items should be
    # displayed given the current context and renders them appropriately.
    #
    # The entire component is rendered within one ul element.
    class TabbedNavigation < Component

      attr_reader :menu

      # Build a new tabbed navigation component.
      #
      # @param [ActiveAdmin::Menu] menu the Menu to render
      # @param [Hash] options the options as passed to the underlying ul element.
      #
      def build(menu, options = {})
        @menu = menu
        super(options.reverse_merge(id: 'tabs'))

        menu_items.each do |item|
          menu_item(item)
        end
      end

      # The top-level menu items that should be displayed.
      def menu_items
        menu.items(self)
      end

      def tag_name
        'ul'
      end
    end

    class MenuItem < Component
      builder_method :menu_item

      def build(item, options = {})
        super(options.merge(id: item.id))

        add_class "current" if item.current? assigns[:current_tab]

        if url = item.url(self)
          a item.label(self), item.html_options.merge(href: url)
        else
          span item.label(self), item.html_options
        end

        if children = item.items(self).presence
          add_class "has_nested"

          ul do
            children.each do |child|
              menu_item(child)
            end
          end
        end
      end

      def tag_name
        'li'
      end
    end
  end
end
