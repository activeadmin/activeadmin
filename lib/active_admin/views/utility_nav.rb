module ActiveAdmin
  module Views
    class UtilityNav < Component
      def tag_name
        "p"
      end

      def build(namespace)
        super(:id => "utility_nav", :class => "header-item")
        @namespace = namespace

        if current_active_admin_user?
          build_current_user
          build_logout_link
        end
      end

      private

      def build_current_user
        span display_name(current_active_admin_user), :class => "current_user"
      end

      def build_logout_link
        if @namespace.logout_link_path
          text_node helpers.link_to(I18n.t('active_admin.logout'), active_admin_logout_path, :method => logout_method)
        end
      end

      # Returns the logout path from the application settings
      def active_admin_logout_path
        helpers.render_or_call_method_or_proc_on(self, @namespace.logout_link_path)
      end

      def logout_method
        @namespace.logout_link_method || :get
      end

    end
  end
end
