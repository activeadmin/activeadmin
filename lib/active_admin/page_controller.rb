module ActiveAdmin
  # Note: I could try to just inherit from ResourceController
  class PageController < BaseController

    layout false # Page page is a subclass of Base page.

    actions :index

    include ActiveAdmin::ResourceController::PageConfigurations
    include ActiveAdmin::ResourceController::Menu

    def index(options={}, &block)
      arbre_block = index_config.block
      render "active_admin/page/index"
    end
  end
end
