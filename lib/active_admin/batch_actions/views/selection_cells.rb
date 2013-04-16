require 'active_admin/component'

module ActiveAdmin
  module BatchActions

    # Creates the toggle checkbox used to toggle the collection selection on/off
    class ResourceSelectionToggleCell < ActiveAdmin::Component
      builder_method :resource_selection_toggle_cell

      def build
        input( :type => "checkbox", :id => "collection_selection_toggle_all", :name => "collection_selection_toggle_all", :class => "toggle_all" )
      end
    end

    # Creates the checkbox used to select a resource in the collection selection
    class ResourceSelectionCell < ActiveAdmin::Component
      builder_method :resource_selection_cell

      def build(resource)
        input :type => "checkbox", :id => "batch_action_item_#{resource.id}", :value => resource.id, :class => "collection_selection", :name => "collection_selection[]"
      end
    end

    # Creates a wrapper panel for all index pages, except for the table, as the table has the checkbox in the thead
    class ResourceSelectionTogglePanel < ActiveAdmin::Component
      builder_method :resource_selection_toggle_panel

      def build
        super(:id => "collection_selection_toggle_panel")
        resource_selection_toggle_cell
        div(:id => "collection_selection_toggle_explaination" ) { I18n.t('active_admin.batch_actions.selection_toggle_explanation', :default => "(Toggle Selection)") }
      end

    end

  end
end
