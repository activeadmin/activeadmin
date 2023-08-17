# frozen_string_literal: true
module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        svg = '<svg class="w-5 h-5 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/></svg>'
        button svg.html_safe, class: "me-3 inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600", "data-drawer-target": "drawer-navigation", "data-drawer-show": "drawer-navigation", "aria-controls": "drawer-navigation"

        site_title @namespace
        utility_navigation @utility_menu, id: "utility_nav", class: "header-item tabs"
        div id: "drawer-navigation", class: "fixed top-0 left-0 z-40 w-64 h-screen p-4 overflow-y-auto transition-transform duration-200 -translate-x-full bg-white dark:bg-gray-800", tabindex: "-1", "aria-labelledby": "drawer-navigation-label" do
          global_navigation @menu, class: "header-item tabs"
        end
      end

    end
  end
end
