require 'active_admin/abstract_view_factory'

module ActiveAdmin
  class ViewFactory < AbstractViewFactory

    # Register Helper Renderers
    register  :global_navigation  => ActiveAdmin::Views::TabbedNavigation,
              :action_items       => ActiveAdmin::Views::ActionItems,
              :header             => ActiveAdmin::Views::HeaderRenderer,
              :dashboard_section  => ActiveAdmin::Views::DashboardSection,
              :index_scopes       => ActiveAdmin::Views::Scopes,
              :blank_slate        => ActiveAdmin::Views::BlankSlate

    # Register All The Pages
    register  :dashboard_page     => ActiveAdmin::Views::Pages::Dashboard,
              :index_page         => ActiveAdmin::Views::Pages::Index,
              :show_page          => ActiveAdmin::Views::Pages::Show,
              :new_page           => ActiveAdmin::Views::Pages::Form,
              :edit_page          => ActiveAdmin::Views::Pages::Form,
              :layout             => ActiveAdmin::Views::Pages::Layout,
              :page               => ActiveAdmin::Views::Pages::Page

  end
end
