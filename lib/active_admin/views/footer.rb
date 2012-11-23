module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        powered_by_message
      end

      private

      def powered_by_message
        para do
          small "Powered by #{link_to("Active Admin", "http://www.activeadmin.info")} #{ActiveAdmin::VERSION}".html_safe
        end
      end

    end
  end
end
