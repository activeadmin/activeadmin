module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(:id => "header")

        @namespace = namespace
        @menu = menu

        build_site_title
        build_global_navigation
        build_utility_navigation
      end


      def build_site_title
        insert_tag view_factory.site_title, @namespace
      end

      def build_global_navigation
        insert_tag view_factory.global_navigation, @menu, :class => 'header-item' 
      end

      def build_utility_navigation
        insert_tag view_factory.utility_navigation, @namespace
      end

    end
  end
end
