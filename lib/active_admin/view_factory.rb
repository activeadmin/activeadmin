require 'active_admin/abstract_view_factory'

module ActiveAdmin
  class ViewFactory < AbstractViewFactory

    # Register Helper Renderers
    register  :global_navigation  => ActiveAdmin::Views::TabsRenderer,
              :sidebar            => ActiveAdmin::Views::SidebarRenderer,
              :action_items       => ActiveAdmin::Views::ActionItemsRenderer,
              :header             => ActiveAdmin::Views::HeaderRenderer,
              :dashboard_section  => ActiveAdmin::Views::DashboardSectionRenderer,
              :admin_notes        => ActiveAdmin::Views::AdminNotesRenderer

    # Register All The Pages
    register  :dashboard_page     => ActiveAdmin::Views::DashboardPage,
              :index_page         => ActiveAdmin::Views::IndexPage,
              :show_page          => ActiveAdmin::Views::ShowPage,
              :new_page           => ActiveAdmin::Views::NewPage,
              :edit_page          => ActiveAdmin::Views::EditPage

  end
end
