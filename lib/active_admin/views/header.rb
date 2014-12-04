module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        classes = Arbre::HTML::ClassList.new
        classes << "navigation"
        classes << "has_subnav" if has_sub_nav?

        div class: classes do
          build_site_title
          build_global_navigation
          build_utility_navigation
        end

        build_sub_navigation

      end

      def build_site_title
        insert_tag view_factory.site_title, @namespace
      end

      def build_global_navigation
        insert_tag view_factory.global_navigation, @menu, class: 'header-item tabs'
      end

      def build_sub_navigation
        if has_sub_nav?
          div class: "subnav" do
            menu = active_admin_config.sub_navigation_menu
            insert_tag view_factory.sub_navigation, menu, :class => "tabs"
          end
        end
      end

      def build_utility_navigation
        insert_tag view_factory.utility_navigation, @utility_menu, id: "utility_nav", class: 'header-item tabs'
      end

      private

      def has_sub_nav?
        (active_admin_config.belongs_to? && !active_admin_config.has_nested_resources?) || active_admin_config.show_sub_menu?(params[:action])
      end

    end
  end
end
