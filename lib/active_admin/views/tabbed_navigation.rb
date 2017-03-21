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

      def default_class
        'navbar-nav mr-auto'
      end

      # Build a new tabbed navigation component.
      #
      # @param [ActiveAdmin::Menu] menu the Menu to render
      # @param [Hash] options the options as passed to the underlying ul element.
      #
      def build(menu, options = {})
        @menu = menu
        super(default_options.merge(options))
        build_menu
      end

      # The top-level menu items that should be displayed.
      def menu_items
        menu.items(self)
      end

      def tag_name
        'ul'
      end

      private

      def build_menu
        menu_items.each do |item|
          build_menu_item(item)
        end
      end

      def build_menu_item(item)
        if children = item.items(self).presence
          li id: item.id, class: 'nav-item dropdown' do |li|
            a class: 'nav-link dropdown-toggle', 'data-toggle': 'dropdown' do 
              span item.label(self), item.html_options
            end
            div class: 'dropdown-menu' do
              children.each{ |child| build_child_menu_item child }
            end
          end
        else
          li id:item.id, class: 'nav-item' do |li|
            li.add_class "active" if item.current? assigns[:current_tab]

            if url = item.url(self)
              text_node link_to item.label(self), url, item.html_options.merge({class: 'nav-link'})
            else
              span item.label(self), item.html_options
            end
          end
        end
      end

      def build_child_menu_item(item)
        if url = item.url(self)
          text_node link_to item.label(self), url, item.html_options.merge({class: 'dropdown-item'})
        else
          span item.label(self), item.html_options
        end
      end

      def default_options
        {}
      end

    end
  end
end
