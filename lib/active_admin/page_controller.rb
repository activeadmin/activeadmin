module ActiveAdmin

  # All Pages controllers inherit from this controller.
  class PageController < BaseController

    # Active admin actions don't require layout.  All custom actions do.
    ACTIVE_ADMIN_ACTIONS = [:index]

    actions :index

    if ActiveAdmin::Dependency.rails >= 4
      before_action :authorize_access!
    else
      before_filter :authorize_access!
    end

    def index(options={}, &block)
      render "active_admin/page/index"
    end

    def clear_page_actions!
      active_admin_config.clear_page_actions!
    end

    private

    def authorize_access!
      permission = action_to_permission(params[:action])
      authorize! permission, active_admin_config
    end

  end
end
