module ActiveAdmin
  module Views
    class Header < Component

      def tag_name
        'nav'
      end

      def default_class_name
        'navbar navbar-toggleable-md navbar-inverse bg-inverse fixed-top'
      end

      def build(namespace, menu)
        super()

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        button class: 'navbar-toggler navbar-toggler-right', type: 'button', 'data-toggle': 'collapse', 'data-target': '#navbarsMain' do 
          span class: 'navbar-toggler-icon'
        end
        build_site_title
        div class: 'collapse navbar-collapse', id: "navbarsMain" do
          build_global_navigation
          build_utility_navigation
        end
      end

      def build_site_title
        insert_tag view_factory.site_title, @namespace
      end

      def build_global_navigation
        insert_tag view_factory.global_navigation, @menu, class: 'navbar-nav mr-auto'
      end

      def build_utility_navigation
        insert_tag view_factory.utility_navigation, @utility_menu, class: 'navbar-nav justify-content-end'
      end

    end
  end
end
