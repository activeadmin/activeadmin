module ActiveAdmin
  class ResourceController < ::InheritedResources::Base
    module Menu
      extend ActiveSupport::Concern

      included do
        before_filter :set_current_tab
        helper_method :current_menu
      end

      protected

      def current_menu
        menu = active_admin_config.namespace.menu
        nested_menus(menu) # add in any nested menus
      end

      # include menus based on our current resource and any resources that
      # belong_to it. we do this later in the game because we need to know
      # what the user is currently viewing to know what to render
      def nested_menus(menu)

        resources = ActiveAdmin::Resource.belongs_to_resources(params[:controller])

        resources.each do |resource|

          # convert our target resource into a routes style name
          target = resource.belongs_to_config.target.underscored_resource_name

          # we need to supply the parent resource's id. the param for this
          # differs if we're on the show page for that resource, or if we're
          # actually nested.
          parent_id = eval("params[:#{target}_id]")
          parent_id ||= params[:id]

          # make sure we actually have what we need to do this
          if parent_id and nested?

            routes_for = "#{target}_#{resource.route_collection_path}(parent_id)"
            add_to = menu

            # Adding as a child
            if resource.parent_menu_item_name
              # Create the parent if it doesn't exist
              menu.add(resource.parent_menu_item_name, '#') unless menu[resource.parent_menu_item_name]
              add_to = menu[resource.parent_menu_item_name]
            end

            # Check if this menu item has already been created
            if add_to[resource.menu_item_name]
              # Update the url if it's already been created
              add_to[resource.menu_item_name].url = eval(routes_for)
            else
              add_to.add(resource.menu_item_name, eval(routes_for), resource.menu_item_priority, { :if => resource.menu_item_display_if })
            end

          end

        end

        return menu

      end



      # Set's @current_tab to be name of the tab to mark as current
      # Get's called through a before filter
      # if we're not nested, we want to select the parent resource
      def set_current_tab
        @current_tab = if active_admin_config.belongs_to? && parent? && !nested?
          active_admin_config.belongs_to_config.target.menu_item_name
        else
          [active_admin_config.parent_menu_item_name, active_admin_config.menu_item_name].compact.join("/")
        end
      end

      def nested?
        active_admin_application.nested_associations ||= false
      end

    end
  end
end
