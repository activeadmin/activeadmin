# frozen_string_literal: true
module ActiveAdmin
  module Views
    class UnsupportedBrowser < Component
      def build
        h1 I18n.t("active_admin.unsupported_browser.headline").html_safe
        para I18n.t("active_admin.unsupported_browser.recommendation").html_safe
        para I18n.t("active_admin.unsupported_browser.turn_off_compatibility_view").html_safe
      end
    end
  end
end
