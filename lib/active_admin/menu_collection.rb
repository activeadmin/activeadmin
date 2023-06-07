# frozen_string_literal: true
module ActiveAdmin

  DEFAULT_MENU = :default

  # A MenuCollection stores multiple menus for any given namespace. Namespaces delegate
  # the addition of menu items to this class.
  class MenuCollection
    def initialize
      @menus = {}
      @build_callbacks = []
      @built = false
    end

    # Add a new menu item to a menu in the collection
    def add(menu_name, menu_item_options = {})
      menu = find_or_create(menu_name)

      menu.add menu_item_options
    end

    def clear!
      @menus = {}
      @built = false
    end

    def exists?(menu_name)
      @menus.keys.include? menu_name
    end

    def fetch(menu_name)
      build_menus!

      @menus[menu_name] or
        raise NoMenuError, "No menu by the name of #{menu_name.inspect} in available menus: #{@menus.keys.join(", ")}"
    end

    # Add callbacks that will be run when the menu is going to be built. This
    # helps use with reloading and allows configurations to add items to menus.
    #
    # @param [Proc] block A block which will be ran when the menu is built. The
    #                   will have the menu collection yielded.
    def on_build(&block)
      @build_callbacks << block
    end

    # Add callbacks that will be run before the menu is built
    def before_build(&block)
      @build_callbacks.unshift(block)
    end

    def menu(menu_name)
      menu = find_or_create(menu_name)

      yield(menu) if block_given?

      menu
    end

    private

    def built?
      @built
    end

    def build_menus!
      return if built?

      build_default_menu
      run_on_build_callbacks

      @built = true
    end

    def run_on_build_callbacks
      @build_callbacks.each do |callback|
        callback.call(self)
      end
    end

    def build_default_menu
      find_or_create DEFAULT_MENU
    end

    def find_or_create(menu_name)
      menu_name ||= DEFAULT_MENU
      @menus[menu_name] ||= ActiveAdmin::Menu.new
    end

  end

end
