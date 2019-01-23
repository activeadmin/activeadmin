module ActiveAdmin
  class Resource

    module Menu

      # Set the menu options.
      # To disable this menu item, call `menu(false)` from the DSL
      def menu_item_options=(options)
        if options == false
          @include_in_menu   = false
          @menu_item_options = {}
        else
          @include_in_menu = true
          @navigation_menu_name = options[:menu_name]
          @menu_item_options    = default_menu_options.merge options
        end
      end

      def menu_item_options
        @menu_item_options ||= default_menu_options
      end

      def default_menu_options
        # These local variables are accessible to the procs.
        menu_resource_class = respond_to?(:resource_class) ? resource_class : self
        resource = self
        {
          id: resource_name.plural,
          label: proc { resource.plural_resource_label },
          url:   proc { resource.route_collection_path(params, url_options) },
          if:    proc { authorized?(Auth::READ, menu_resource_class) }
        }
      end

      def navigation_menu_name=(menu_name)
        self.menu_item_options = { menu_name: menu_name }
      end

      def navigation_menu_name
        case @navigation_menu_name ||= DEFAULT_MENU
        when Proc
          controller.instance_exec(&@navigation_menu_name).to_sym
        else
          @navigation_menu_name
        end
      end

      def navigation_menu
        namespace.fetch_menu(navigation_menu_name)
      end

      def add_to_menu(menu_collection)
        if include_in_menu?
          @menu_item = menu_collection.add navigation_menu_name, menu_item_options
        end
      end

      attr_reader :menu_item

      # Should this resource be added to the menu system?
      def include_in_menu?
        @include_in_menu != false
      end

    end
  end
end
