require 'active_admin/helpers/collection'

module ActiveAdmin
  module Views
    module Pages

      class Index < Base

        def title
          case config[:title]
          when Proc then controller.instance_eval(&config[:title])
          when String then config[:title]
          else
            active_admin_config.plural_resource_label
          end
        end

        def config
          active_admin_config.get_page_presenter(:index, params[:as]) || default_index_config
        end

        # Render's the index configuration that was set in the
        # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
        def main_content
          wrap_with_batch_action_form do
            build_table_tools
            build_collection
          end
        end

        protected

        def wrap_with_batch_action_form(&block)
          if active_admin_config.batch_actions.any?
            batch_action_form(&block)
          else
            block.call
          end
        end

        include ::ActiveAdmin::Helpers::Collection

        def items_in_collection?
          !collection_is_empty?
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

        include ::ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper

        def build_table_tools
          div :class => "table_tools" do
            build_batch_actions_selector
            build_scopes
            build_index_list
          end if any_table_tools?
        end

        def any_table_tools?
          active_admin_config.batch_actions.any? ||
          active_admin_config.scopes.any? ||
          active_admin_config.page_presenters[:index].try(:size).try(:>, 1)
        end

        def build_batch_actions_selector
          if active_admin_config.batch_actions.any?
            insert_tag view_factory.batch_action_selector, active_admin_config.batch_actions
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

        def build_index_list
          indexes = active_admin_config.page_presenters[:index]

          if indexes.kind_of?(Hash) && indexes.length > 1
            index_classes = []
            active_admin_config.page_presenters[:index].each do |type, page_presenter|
              index_classes << find_index_renderer_class(page_presenter[:as])
            end

            index_list_renderer index_classes
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
        def find_index_renderer_class(klass)
          klass.is_a?(Class) ? klass :
            ::ActiveAdmin::Views.const_get("IndexAs" + klass.to_s.camelcase)
        end

        def render_blank_slate
          blank_slate_content = I18n.t("active_admin.blank_slate.content", :resource_name => active_admin_config.plural_resource_label)
          if controller.action_methods.include?('new')
            blank_slate_content += " " + link_to(I18n.t("active_admin.blank_slate.link"), new_resource_path)
          end
          insert_tag(view_factory.blank_slate, blank_slate_content)
        end

        def render_empty_results
          empty_results_content = I18n.t("active_admin.pagination.empty", :model => active_admin_config.plural_resource_label)
          insert_tag(view_factory.blank_slate, empty_results_content)
        end

        def render_index
          renderer_class = find_index_renderer_class(config[:as])
          paginator      = config[:paginator].nil?      ? true : config[:paginator]
          download_links = config[:download_links].nil? ? active_admin_config.namespace.download_links : config[:download_links]

          paginated_collection(collection, :entry_name     => active_admin_config.resource_label,
                                           :entries_name   => active_admin_config.plural_resource_label(:count => collection_size),
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

