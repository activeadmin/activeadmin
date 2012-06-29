module ActiveAdmin

  class MenuBuilder

    def self.build_for_namespace(namespace)
      new(namespace).menu
    end

    attr_reader :menu

    def initialize(namespace)
      @namespace = namespace
    end

    def menu
      @menu ||= build_menu
    end

    private

    def namespace
      @namespace
    end

    def build_menu
      menu = Menu.new

      Dashboards.add_to_menu(namespace, menu)

      namespace.resources.each do |resource|
        register_with_menu(menu, resource) if resource.include_in_menu?
      end

      menu
    end

    # Does all the work of registernig a config with the menu system
    def register_with_menu(menu, resource)
      # The menu we're going to add this resource to
      add_to = menu

      # Adding as a child
      if resource.parent_menu_item_name
        # Create the parent if it doesn't exist
        unless menu[resource.parent_menu_item_name]
          item = MenuItem.new(:label => resource.parent_menu_item_name, :url => "#", :id => resource.parent_menu_item_name)
          add_to.add(item)
        end

        add_to = menu[resource.parent_menu_item_name]
      end

      if add_to[resource.menu_item.id]
        existing = add_to[resource.menu_item.id]
        add_to.children.delete(existing)
        add_to.add(resource.menu_item)
        resource.menu_item.add(*existing.children)
      else
        add_to.add resource.menu_item
      end
    end

  end

end
