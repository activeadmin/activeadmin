module ActiveAdmin
  module Views

    class IndexPage < BasePage

      def title
        active_admin_config.plural_resource_name
      end

      def config
        index_config || default_index_config
      end

      def scopes
        render ActiveAdmin.view_factory.index_scopes, active_admin_config.scopes
      end

      # Render's the index configuration that was set in the
      # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
      def main_content
        renderer_class = find_index_renderer_class(config[:as])
        scopes + 
          wrap_with_pagination(collection, :entry_name => active_admin_config.resource_name) do
            renderer_class.new(self).to_html(config, collection)
          end
      end

      private

      # Creates a default configuration for the resource class. This is a table
      # with each column displayed as well as all the default actions
      def default_index_config
        @default_index_config ||= ::ActiveAdmin::PageConfig.new(:as => :table) do |display|
          display.id
          resource_class.content_columns.each do |column|
            display.column column.name.to_sym
          end
          display.default_actions
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

    end
  end
end

