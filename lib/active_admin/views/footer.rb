module ActiveAdmin
  module Views
    class Footer < Component

      def build(namespace)
        super id: "footer"
        @namespace = namespace

        if footer_text.present?
          para footer_text
        else
          para powered_by_message
        end
      end

      private

      def footer_text
        @footer_text ||= @namespace.footer(self)
      end

      def powered_by_message
        I18n.t('active_admin.powered_by',
          active_admin: link_to("Active Admin", "https://activeadmin.info"),
          version: ActiveAdmin::VERSION).html_safe
      end

    end
  end
end
