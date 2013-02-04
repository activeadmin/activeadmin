module ActiveAdmin

  DEFAULT_MENU = :default

  # A MenuCollection stores multiple menus for any given namespace. Namespaces delegate
  # the addition of menu items to this class.
  class MenuCollection

    NoMenuError = Class.new(KeyError)

    def initialize
      @menus = {}
      build_default_menu
    end

    # Add a new menu item to a menu in the collection
    def add(menu_name, menu_item_options = {})
      menu = find_or_create(menu_name)

      menu.add menu_item_options
    end

    def clear!
      @menus = {}
      build_default_menu
    end

    def fetch(menu_name)
      @menus[menu_name] or
        raise NoMenuError, "No menu by the name of #{menu_name.inspect} in availble menus: #{@menus.keys.join(", ")}"
    end

    private

    def build_default_menu
      find_or_create DEFAULT_MENU
    end

    def find_or_create(menu_name)
      menu_name ||= DEFAULT_MENU
      @menus[menu_name] ||= ActiveAdmin::Menu.new
    end

  end

end
