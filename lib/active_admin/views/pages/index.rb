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
          if active_admin_config.batch_actions.any? 
            batch_action_form do
              build_table_tools
              build_collection
            end
          else
            build_table_tools
            build_collection
          end
        end

        protected

        def build_extra_content
          build_batch_action_popover
        end

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

        def build_collection
          if items_in_collection?
            render_index
          else
            if params[:q] || params[:scope]
              render_empty_results
            else
              render_blank_slate
            end
          end
        end

        # TODO: Refactor to new HTML DSL
        def build_download_format_links(formats = [:csv, :xml, :json])
          links = formats.collect do |format|
            link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
          end
          text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
        end

        def build_table_tools
          div :class => "table_tools" do

            if active_admin_config.batch_actions.any?
              a :class => 'table_tools_button dropdown_button disabled', :href => "#batch_actions_popover", :id => "batch_actions_button" do
                text_node I18n.t("active_admin.batch_actions.button_label")
              end
            end
          
            build_scopes
          end
        end

        def build_batch_action_popover
          insert_tag view_factory.batch_action_popover do
            active_admin_config.batch_actions.each do |the_action|
              action the_action if call_method_or_proc_on(self, the_action.display_if_block)
            end
          end
        end

        def build_scopes
          if active_admin_config.scopes.any?
            scope_options = {
              :scope_count => config[:scope_count].nil? ? true : config[:scope_count]
            }

            scopes_renderer active_admin_config.scopes, scope_options
          end
        end

        # Creates a default configuration for the resource class. This is a table
        # with each column displayed as well as all the default actions
        def default_index_config
          @default_index_config ||= ::ActiveAdmin::PagePresenter.new(:as => :table) do |display|
            selectable_column
            id_column
            resource_class.content_columns.each do |col|
              column col.name.to_sym
            end
            default_actions
          end
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

