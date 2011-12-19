module ActiveAdmin
  class Resource
    module Menu

      # Set the menu options. To not add this resource to the menu, just
      # call #menu(false)
      def menu(options = {})
        options = options == false ? { :display => false } : options
        @menu_options = options
      end

      # The options to use for the menu
      def menu_options
        @menu_options ||= {}
      end

      # Returns the name to put this resource under in the menu
      def parent_menu_item_name
        menu_options[:parent]
      end

      # Returns the name to be displayed in the menu for this resource
      def menu_item_name
        menu_options[:label] || plural_resource_name
      end

      # Returns the items priority for altering the default sort order
      def menu_item_priority
        menu_options[:priority] || 10
      end

      # Returns a proc for deciding whether to display the menu item or not in the view
      def menu_item_display_if
        menu_options[:if] || proc { true }
      end

      # Should this resource be added to the menu system?
      def include_in_menu?
        menu_options[:display] != false
      end

    end
  end
end
