# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    blank_slate do
      h2 I18n.t("active_admin.dashboard_welcome.welcome"), class: "mt-2 text-base font-semibold leading-6 text-gray-900 dark:text-gray-200"
      para I18n.t("active_admin.dashboard_welcome.call_to_action"), class: "mt-1 text-sm text-gray-500 dark:text-gray-400"
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # div class: "grid grid-cols-1 md:grid-cols-2 gap-4 my-4" do
    #   div do
    #     panel "Recent Posts" do
    #       para "Display some recent posts."
    #     end
    #   end

    #   div do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
