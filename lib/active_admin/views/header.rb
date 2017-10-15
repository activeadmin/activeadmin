module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        build_site_title
        build_global_navigation
        build_utility_navigation
      end

      def build_site_title
        site_title @namespace
      end

      def build_global_navigation
        global_navigation @menu, class: 'header-item tabs'
      end

      def build_utility_navigation
        utility_navigation @utility_menu, id: "utility_nav", class: 'header-item tabs'
      end

    end
  end
end
