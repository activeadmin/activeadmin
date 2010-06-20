module ActiveAdmin
  module Pages

    class Index < Base
      def title
        resources_name
      end

      # Render's the index configuration that was set in the
      # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
      def main_content
        index_config.render(self, collection)
      end


      #
      # Index Page Configurations
      #      

      class Table < PageConfig

        attr_reader :table_builder

        def initialize(*args, &block)
          @table_builder = TableBuilder.new(&block)
          super
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
            column options[:name] do 
              links = link_to "View", resource_path(resource)
              links += " | "
              links += link_to "Edit", edit_resource_path(resource)
              links += " | "
              links += link_to "Delete", resource_path(resource), :method => :delete, :confirm => "Are you sure you want to delete this?"
              links
            end
          end          

        end

        def render(view, collection)
          Renderer.new(view).to_html(self, collection)
        end

        class Renderer < ::ActiveAdmin::Renderer

          def to_html(config, collection)
            wrap_with_pagination(collection, :entry_name => resource_name) do
              table_options = {
                :id => resource_name.underscore.pluralize, 
                :resource_instance_name => resource_name.underscore,
                :sortable => true,
                :class => "index_table", 
              }
              config.table_builder.to_html(self, collection, table_options)
            end
          end

        end # Renderer
      end # Table

    end
  end
end
