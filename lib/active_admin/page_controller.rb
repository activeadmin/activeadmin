module ActiveAdmin

  # All Pages controllers inherit from this controller.
  class PageController < BaseController

    # Pages::Page subclasses Page::Base which implements the layout code
    layout false

    actions :index

    def index(options={}, &block)
      arbre_block = index_config.block
      render "active_admin/page/index"
    end
  end
end
