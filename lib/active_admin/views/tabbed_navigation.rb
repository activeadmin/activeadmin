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
        dom_id = case item.dom_id
        when Proc,Symbol
          normalize_id call_method_or_proc_on(self, item.dom_id)
        else
          item.dom_id
        end

        li :id => dom_id do |li_element|
          li_element.add_class "current" if current?(item)

          if item.items.any?
            li_element.add_class "has_nested"
            actual_item_link item
            render_nested_menu(item)
          else
            actual_item_link item
          end
        end
      end

      def normalize_id(string)
        string.to_s.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/, '')
      end

      def actual_item_link(item)

        label = case item.label
        when Symbol
          send item.label
        when Proc
          item.label.call rescue instance_exec(&item.label)
        else
          item.label.to_s
        end

        link_path = url_for_menu_item(item)
        text_node link_to(label, link_path, item.html_options)

      end

      def url_for_menu_item(menu_item)
        case menu_item.url
        when Symbol
          send(menu_item.url)
        when Proc
          instance_exec &menu_item.url
        when nil
          "#"
        else
          menu_item.url
        end
      end

      def render_nested_menu(item)
        ul do
          displayable_items(item.items).each do |child|
            build_menu_item child
          end
        end
      end

      def default_options
        { :id => "tabs" }
      end

      # Returns true if the menu item name is @current_tab (set in controller)
      def current?(menu_item)
        assigns[:current_tab] == menu_item || menu_item.items.include?(assigns[:current_tab])
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
        return true if (item.url.nil? or item.url == '#') && item.items.empty?
        return false if (item.url.nil? or item.url == '#') && !displayable_children?(item)
        true
      end

      # Returns true if the item has any children that should be displayed
      def displayable_children?(item)
        !item.items.find{|child| display_item?(child) }.nil?
      end
    end

  end
end
