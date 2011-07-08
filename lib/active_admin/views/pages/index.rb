module ActiveAdmin
  module Views
    module Pages

      class Index < Base

        def title
          active_admin_config.plural_resource_name
        end

        def config
          index_config || default_index_config
        end


        # Render's the index configuration that was set in the
        # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
        def main_content
          build_scopes
          renderer_class = find_index_renderer_class(config[:as])

          if active_admin_config.resource.all.empty?
            render_blank_slate
          elsif collection.empty?
            render_empty_results
          else
            paginated_collection(collection, :entry_name => active_admin_config.resource_name) do
              div :class => 'index_content' do
                insert_tag(renderer_class, config, collection)
              end
            end
          end
        end

        protected

        def build_scopes
          if active_admin_config.scopes.any?
            scopes_renderer active_admin_config.scopes
          end
        end

        # Creates a default configuration for the resource class. This is a table
        # with each column displayed as well as all the default actions
        def default_index_config
          @default_index_config ||= ::ActiveAdmin::PageConfig.new(:as => :table) do |display|
            id_column
            resource_class.content_columns.each do |col|
              column col.name.to_sym
            end
            default_actions
          end
        end

        # Returns the actual class for renderering the main content on the index
        # page. To set this, use the :as option in the page_config block.
        def find_index_renderer_class(symbol_or_class)
          case symbol_or_class
          when Symbol
            ::ActiveAdmin::Views.const_get("IndexAs" + symbol_or_class.to_s.camelcase)
          when Class
            symbol_or_class
          else
            raise ArgumentError, "'as' requires a class or a symbol"
          end
        end
        
        def render_blank_slate
          if controller.action_methods.include?('new')
            blank_slate_content = I18n.t("active_admin.blank_slate.content", :resource_name => active_admin_config.resource_name.pluralize) +
              " " +
                link_to(I18n.t("active_admin.blank_slate.link"), new_resource_path)
            insert_tag(view_factory.blank_slate, blank_slate_content)
          else
            blank_slate_content = I18n.t("active_admin.blank_slate.content", :resource_name => active_admin_config.resource_name.pluralize)
            insert_tag(view_factory.blank_slate, blank_slate_content)
          end
        end
        
        def render_empty_results
          empty_results_content = I18n.t("active_admin.pagination.empty", :model => active_admin_config.resource_name.pluralize)
          insert_tag(view_factory.blank_slate, empty_results_content)
        end

      end
    end
  end
end

