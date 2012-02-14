module ActiveAdmin
  module Views
    module Pages

      class Index < Base

        def title
          active_admin_config.plural_resource_name
        end

        def config
          active_admin_config.get_page_presenter(:index) || default_index_config
        end

        # Render's the index configuration that was set in the
        # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
        def main_content
          build_scopes

          if items_in_collection?
            render_index
          else
            if params[:q]
              render_empty_results
            else
              render_blank_slate
            end
          end
        end

        protected

        def items_in_collection?
          # Remove the order clause before limiting to 1. This ensures that
          # any referenced columns in the order will not try to be accessed.
          #
          # When we call #exists?, the query's select statement is changed to "1".
          #
          # If we don't reorder, there may be some columns referenced in the order
          # clause that requires the original select.
          collection.reorder("").limit(1).exists?
        end

        # TODO: Refactor to new HTML DSL
        def build_download_format_links(formats = [:csv, :xml, :json])
          links = formats.collect do |format|
            link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
          end
          text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
        end

        def build_scopes
          if active_admin_config.scopes.any?
            scope_options = {
              :scope_count => config[:scope_count].nil? ? true : config[:scope_count]
            }

            div :class => "table_tools" do
              scopes_renderer active_admin_config.scopes, scope_options
            end
          end
        end

        # Creates a default configuration for the resource class. This is a table
        # with each column displayed as well as all the default actions
        def default_index_config
          @default_index_config ||= ::ActiveAdmin::PagePresenter.new(:as => :table)
        end

        # Returns the actual class for renderering the main content on the index
        # page. To set this, use the :as option in the page_presenter block.
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
          blank_slate_content = I18n.t("active_admin.blank_slate.content", :resource_name => active_admin_config.plural_resource_name)
          if controller.action_methods.include?('new')
            blank_slate_content += " " + link_to(I18n.t("active_admin.blank_slate.link"), new_resource_path)
          end
          insert_tag(view_factory.blank_slate, blank_slate_content)
        end
        
        def render_empty_results
          empty_results_content = I18n.t("active_admin.pagination.empty", :model => active_admin_config.resource_name.pluralize)
          insert_tag(view_factory.blank_slate, empty_results_content)
        end
        
        def render_index
          renderer_class = find_index_renderer_class(config[:as])
          paginator      = config[:paginator].nil?      ? true : config[:paginator]
          download_links = config[:download_links].nil? ? true : config[:download_links]
          
          paginated_collection(collection, :entry_name     => active_admin_config.resource_name,
                                           :entries_name   => active_admin_config.plural_resource_name,
                                           :download_links => download_links,
                                           :paginator      => paginator) do
            div :class => 'index_content' do
              insert_tag(renderer_class, config, collection)
            end
          end
        end

      end
    end
  end
end

