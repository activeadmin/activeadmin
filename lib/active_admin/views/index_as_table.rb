module ActiveAdmin
  module Views

    class IndexAsTable < ActiveAdmin::Component

      def build(page_config, collection)
        table_options = {
          :id => active_admin_config.plural_resource_name.underscore, 
          :sortable => true,
          :class => "index_table"
        }
        table_for collection, table_options do |t|
          instance_exec(t, &page_config.block)
        end
      end

      def table_for(*args, &block)
        insert_tag IndexTableFor, *args, &block
      end

      #
      # Extend the default ActiveAdmin::Views::TableFor with some
      # methods for quickly displaying items on the index page
      #
      class IndexTableFor < ::ActiveAdmin::Views::TableFor

        # Display a column for the id
        def id_column
          column('ID', :sortable => :id){|resource| link_to resource.id, resource_path(resource), :class => "resource_id_link"}
        end

        # Adds links to View, Edit and Delete
        def default_actions(options = {})
          options = {
            :name => ""
          }.merge(options)
          column options[:name] do |resource|
            links = link_to "View", resource_path(resource), :class => "view_link"
            links += link_to "Edit", edit_resource_path(resource), :class => "edit_link"
            links += link_to "Delete", resource_path(resource), :method => :delete, :confirm => "Are you sure you want to delete this?", :class => "delete_link"
            links
          end
        end

        # Display A Status Tag Column
        #
        #   index do |i|
        #     i.status_tag :state
        #   end
        #
        #   index do |i|
        #     i.status_tag "State", :status_name
        #   end
        #
        #   index do |i|
        #     i.status_tag do |post|
        #       post.published? ? 'published' : 'draft'
        #     end
        #   end
        #   
        def status_tag(*args, &block)
          col = Column.new(*args, &block)
          data = col.data
          col.data = proc do |resource|
            status_tag call_method_or_proc_on(resource, data)
          end
          add_column col
        end
      end # TableBuilder

    end # Table
  end
end
