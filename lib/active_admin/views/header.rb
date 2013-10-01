module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        div class: "navigation" do
          build_site_title
          build_global_navigation
          build_utility_navigation
        end

        div class: "subnav" do
          build_sub_navigation
        end
      end

      def build_site_title
        insert_tag view_factory.site_title, @namespace
      end

      def build_global_navigation
        insert_tag view_factory.global_navigation, @menu, class: 'header-item tabs'
      end

      def build_sub_navigation
        if active_admin_config.belongs_to?
          menu = active_admin_config.sub_navigation_menu
          insert_tag view_factory.sub_navigation, menu, :class => "tabs"
        end
      end

      def build_utility_navigation
        insert_tag view_factory.utility_navigation, @utility_menu, id: "utility_nav", class: 'header-item tabs'
      end

    end
  end
end
