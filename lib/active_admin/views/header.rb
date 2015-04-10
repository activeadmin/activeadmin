# frozen_string_literal: true
module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header", class: "main-navbar")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        site_title @namespace
        global_navigation @menu, class: "main-navigation tabs"
        utility_navigation @utility_menu, id: "utility_nav", class: "main-utility-navigation tabs"
      end

    end
  end
end
