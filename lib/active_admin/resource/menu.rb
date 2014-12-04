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
          label: proc{ resource.plural_resource_label },
          url:   proc{ resource.route_collection_path(params) },
          if:    proc{ authorized?(:read, menu_resource_class) }
        }
      end

      attr_writer :navigation_menu_name, :sub_navigation_menu_name

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

      def sub_navigation_menu
        if has_nested_resources? && !sub_menu_item?
          menu = resource_name.to_s.underscore.to_sym
          namespace.sub_menus.fetch(menu)
        else
          namespace.sub_menus.fetch(@sub_navigation_menu_name)
        end
      end

      def add_to_menu(menu_collection)
        if include_in_menu? && !sub_menu_item?
          @menu_item = menu_collection.add navigation_menu_name, menu_item_options
        end
      end

      def add_to_sub_menu(menu_collection)
        if include_in_menu? && sub_menu_item?
          @menu_item = menu_collection.add @sub_navigation_menu_name, menu_item_options
        end
      end

      attr_reader :menu_item

      # Should this resource be added to the menu system?
      def include_in_menu?
        @include_in_menu != false
      end

      def sub_menu_item?
        !@sub_navigation_menu_name.nil?
      end

    end
  end
end
