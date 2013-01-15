module ActiveAdmin

  # All Pages controllers inherit from this controller.
  class PageController < BaseController

    # Active admin actions don't require layout.  All custom actions do.
    ACTIVE_ADMIN_ACTIONS = [:index]

    actions :index

    def index(options={}, &block)
      render "active_admin/page/index"
    end

    def clear_page_actions!
      active_admin_config.clear_page_actions!
    end

  end
end
