module ActiveAdmin
  module Pages
    class Index

      class Table < Renderer

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

          # Adds links to View, Edit and Delete
          def default_actions(options = {})
            options = {
              :name => ""
            }.merge(options)
            column options[:name] do |resource|
              links = link_to "View", resource_path(resource)
              links += " | "
              links += link_to "Edit", edit_resource_path(resource)
              links += " | "
              links += link_to "Delete", resource_path(resource), :method => :delete, :confirm => "Are you sure you want to delete this?"
              links
            end
          end
        end # TableBuilder

      end # Table
    end
  end
end
