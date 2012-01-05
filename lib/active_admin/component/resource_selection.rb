module ActiveAdmin
    
    module ResourceSelection
            
      # Creates the toggle checkbox used to toggle the collection selection on/off
      def resource_selection_toggle_cell
        div :class => "resource_selection_toggle_cell" do 
          input( :type => "checkbox", :id => "collection_selection_toggle_all", :name => "collection_selection_toggle_all", :class => "toggle_all" )
        end
      end
      
      # Creates the checkbox used to select a resource in the collection selection
      def resource_selection_cell( resource )
        div :class => "resource_selection_cell" do 
          input :type => "checkbox", :id => "batch_action_item_%d" % resource.id, :value => resource.id, :class => "collection_selection", :name => "collection_selection[]" 
        end
      end
      
      # Creates a wrapper panel for all index pages, except for the table, as the table has the checkbox in the thead
      def resource_selection_toggle_panel
        div( :id => "collection_selection_toggle_panel" ) do 
          resource_selection_toggle_cell
          div( :id => "collection_selection_toggle_explaination" ) { I18n.t('active_admin.selection_toggle_explanation', :default => "(Toggle Selection)") }
          # div :style => "clear:both"
        end
      end
      
    end
    
end
