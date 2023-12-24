# frozen_string_literal: true
module ActiveAdmin

  # All Pages controllers inherit from this controller.
  class PageController < BaseController

    # Active admin actions don't require layout.  All custom actions do.
    ACTIVE_ADMIN_ACTIONS = [:index]

    actions :index

    before_action :authorize_access!

    def index(options = {}, &block)
      render "active_admin/page/index"
    end

    private

    def authorize_access!
      permission = action_to_permission(params[:action])
      authorize! permission, active_admin_config
    end

  end
end
