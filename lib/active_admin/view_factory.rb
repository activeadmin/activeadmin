require 'active_admin/abstract_view_factory'

module ActiveAdmin
  class ViewFactory < AbstractViewFactory

    register  :global_navigation => ActiveAdmin::TabsRenderer

  end
end
