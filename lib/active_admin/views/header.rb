# frozen_string_literal: true
module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        button class: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800", "data-drawer-target": "drawer-navigation", "data-drawer-show": "drawer-navigation", "aria-controls": "drawer-navigation" do
          "Menu"
        end
        site_title @namespace
        utility_navigation @utility_menu, id: "utility_nav", class: "header-item tabs"
        div id: "drawer-navigation", class: "fixed top-0 left-0 z-40 w-64 h-screen p-4 overflow-y-auto transition-transform duration-200 -translate-x-full bg-white dark:bg-gray-800", tabindex: "-1", "aria-labelledby": "drawer-navigation-label" do
          global_navigation @menu, class: "header-item tabs"
        end
      end

    end
  end
end
