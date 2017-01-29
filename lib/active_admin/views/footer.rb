module ActiveAdmin
  module Views
    class Footer < Component

      def build(namespace)
        super id: "footer"
        @namespace = namespace

        if footer?
          para footer_text
        else
          para powered_by_message
        end
      end

      def footer?
        @namespace.footer.present?
      end

      private

      def footer_text
        helpers.render_or_call_method_or_proc_on(self, @namespace.footer)
      end

      def powered_by_message
        I18n.t('active_admin.powered_by',
          active_admin: link_to("Active Admin", "http://www.activeadmin.info"),
          version: ActiveAdmin::VERSION).html_safe
      end

    end
  end
end
