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
        super(default_options.merge(options))
        build_menu
      end

      # Returns the first level menu items to display
      def menu_items
        displayable_items(menu.items)
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
        li :id => item.dom_id do |li_element|
          li_element.add_class "current" if current?(item)

          if item.children.any?
            li_element.add_class "has_nested"
            text_node link_to(item.name, item.url || "#")
            render_nested_menu(item)
          else
            link_to item.name, item.url
          end
        end
      end

      def render_nested_menu(item)
        ul do
          displayable_items(item.children).each do |child|
            build_menu_item child
          end
        end
      end

      def default_options
        { :id => "tabs" }
      end

      # Returns true if the menu item name is @current_tab (set in controller)
      def current?(menu_item)
        assigns[:current_tab].split("/").include?(menu_item.name) unless assigns[:current_tab].blank?
      end

      # Returns an Array of items to display
      def displayable_items(items)
        items.select do |item|
          display_item? item
        end
      end

      # Returns true if the item should be displayed
      def display_item?(item)
        return false unless call_method_or_proc_on(self, item.display_if_block)
        return false if (!item.url || item.url == "#") && !displayable_children?(item)
        true
      end

      # Returns true if the item has any children that should be displayed
      def displayable_children?(item)
        !item.children.find{|child| display_item?(child) }.nil?
      end
    end

  end
end
