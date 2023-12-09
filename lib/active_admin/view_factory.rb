# frozen_string_literal: true
require "active_admin/abstract_view_factory"

module ActiveAdmin
  class ViewFactory < AbstractViewFactory

    # Register Helper Renderers
    register index_scopes: ActiveAdmin::Views::Scopes

    # Register All The Pages
    register index_page: ActiveAdmin::Views::Pages::Index,
             show_page: ActiveAdmin::Views::Pages::Show,
             new_page: ActiveAdmin::Views::Pages::Form,
             edit_page: ActiveAdmin::Views::Pages::Form,
             layout: ActiveAdmin::Views::Pages::Layout,
             page: ActiveAdmin::Views::Pages::Page

  end
end
