module ActiveAdmin
  module Views

    # Renderer for the header of the application. Includes the page
    # title, global navigation and utility navigation.
    class HeaderRenderer < ::ActiveAdmin::Renderer

      def to_html
        title + global_navigation + utility_navigation
      end

      protected

      # Renders the title/branding area for the site
      def title
        content_tag('h1', link_to_site_title(title_image_tag || title_text), :id => 'site_title')
      end

      def link_to_site_title(title_tag)
        if active_admin_namespace.site_title_link.present?
          link_to(title_tag, active_admin_namespace.site_title_link)
        else
          title_tag
        end
      end
      
      # @return [String] An HTML img tag with site_title_image. Return nil when
      # site_title_image is blank.
      def title_image_tag
        if active_admin_namespace.site_title_image.present?
          image_tag(title_image, 
                    :id => "site_title_image", 
                    :alt => active_admin_namespace.site_title)
        end
      end

      # @return [String] The title image url
      def title_image
        render_or_call_method_or_proc_on(self, active_admin_namespace.site_title_image)
      end

      # @return [String] The site title
      def title_text
        render_or_call_method_or_proc_on(self, active_admin_namespace.site_title)
      end

      # Renders the global navigation returned by
      # ActiveAdmin::ResourceController#current_menu
      #
      # It uses the ActiveAdmin.tabs_renderer option
      def global_navigation
        render view_factory.global_navigation, current_menu, :class => 'header-item' 
      end

      def utility_navigation
        content_tag 'p', :id => "utility_nav", :class => 'header-item' do
          if current_active_admin_user?
            html = content_tag(:span, display_name(current_active_admin_user), :class => "current_user")

            if active_admin_namespace.logout_link_path
              html << link_to(I18n.t('active_admin.logout'), active_admin_logout_path, :method => logout_method)
            end
          end
        end
      end

      # Returns the logout path from the application settings
      def active_admin_logout_path
        if active_admin_namespace.logout_link_path.is_a?(Symbol)
          send(active_admin_namespace.logout_link_path)
        else
          active_admin_namespace.logout_link_path
        end
      end

      def logout_method
        active_admin_namespace.logout_link_method || :get
      end
    end

  end
end
