require 'active_admin/abstract_view_factory'

module ActiveAdmin
  class ViewFactory < AbstractViewFactory

    # Register Helper Renderers
    register  global_navigation:   ActiveAdmin::Views::TabbedNavigation,
              utility_navigation:  ActiveAdmin::Views::TabbedNavigation,
              site_title:          ActiveAdmin::Views::SiteTitle,
              action_items:        ActiveAdmin::Views::ActionItems,
              title_bar:           ActiveAdmin::Views::TitleBar,
              header:              ActiveAdmin::Views::Header,
              footer:              ActiveAdmin::Views::Footer,
              index_scopes:        ActiveAdmin::Views::Scopes,
              blank_slate:         ActiveAdmin::Views::BlankSlate,
              action_list_popover: ActiveAdmin::Views::ActionListPopover

    # Register All The Pages
    register  index_page: ActiveAdmin::Views::Pages::Index,
              show_page:  ActiveAdmin::Views::Pages::Show,
              new_page:   ActiveAdmin::Views::Pages::Form,
              edit_page:  ActiveAdmin::Views::Pages::Form,
              layout:     ActiveAdmin::Views::Pages::Layout,
              page:       ActiveAdmin::Views::Pages::Page

  end
end
