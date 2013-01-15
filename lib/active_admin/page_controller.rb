module ActiveAdmin

  # All Pages controllers inherit from this controller.
  class PageController < BaseController

    # Active admin actions don't require layout.  All custom actions do.
    ACTIVE_ADMIN_ACTIONS = [:index]

    layout :determine_active_admin_layout

    actions :index

    def index(options={}, &block)
      render "active_admin/page/index"
    end

    def clear_page_actions!
      active_admin_config.clear_page_actions!
    end

    private

    # Determine which layout to use.
    #
    #   1.  If we're rendering a standard Active Admin action, we want layout(false)
    #       because these actions are subclasses of the Base page (which implements
    #       all the required layout code)
    #   2.  If we're rendering a custom action, we'll use the active_admin layout so
    #       that users can render any template inside Active Admin.
    def determine_active_admin_layout
      ACTIVE_ADMIN_ACTIONS.include?(params[:action].to_sym) ? false : 'active_admin'
    end
  end
end
