module ActiveAdmin
  module Views

    class IndexAsTable < Renderer

      def to_html(page_config, collection)
        wrap_with_pagination(collection, :entry_name => active_admin_config.resource_name) do
          table_options = {
            :id => active_admin_config.plural_resource_name.underscore, 
            :sortable => true,
            :class => "index_table"
          }
          TableBuilder.new(&page_config.block).to_html(self, collection, table_options)
        end
      end

      # 
      # Extend the default ActiveAdmin::TableBuilder with some
      # methods for quickly displaying items on the index page
      #
      class TableBuilder < ::ActiveAdmin::TableBuilder

        # Display a column for the id
        def id
          column('ID', :sortable => :id){|resource| link_to resource.id, resource_path(resource), :class => "resource_id_link"}
        end

        # Adds links to View, Edit and Delete
        def default_actions(options = {})
          options = {
            :name => ""
          }.merge(options)
          column options[:name] do |resource|
            links = link_to icon(:arrow_right_alt1) + "View", resource_path(resource), :class => "view_link"
            links += link_to icon(:pen) + "Edit", edit_resource_path(resource), :class => "edit_link"
            links += link_to icon(:trash_stroke) + "Delete", resource_path(resource), :method => :delete, :confirm => "Are you sure you want to delete this?", :class => "delete_link"
            links
          end
        end
      end # TableBuilder

    end # Table
  end
end
