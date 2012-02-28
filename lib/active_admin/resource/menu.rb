module ActiveAdmin
  class Resource
    module Menu

      # Set the menu options. To not add this resource to the menu, just
      # call #menu(false)
      def menu(options = {})
        if options == false
          @display_menu = false
        else
          options = default_menu_options.merge(options)
          @parent_menu_item = options.delete(:parent)
          @menu_item = MenuItem.new(default_menu_options.merge(options))
        end
      end

      def menu_item
        @menu_item ||= MenuItem.new(default_menu_options)
      end

      def parent_menu_item_name
        return nil unless @parent_menu_item
        ActiveAdmin::Resource::Name.new(nil, @parent_menu_item)
      end

      # The default menu options to pass through to MenuItem.new
      def default_menu_options
        {
          :id => resource_name.plural,
          :label => proc{ plural_resource_label },
          :url => route_collection_path
        }
      end

      # Should this resource be added to the menu system?
      def include_in_menu?
        @display_menu != false
      end

    end
  end
end
