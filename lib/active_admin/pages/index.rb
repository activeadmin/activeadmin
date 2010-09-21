module ActiveAdmin
  module Pages

    class Index < Base

      # Default Index config styles. Each of these are what 
      # actually gets rendered in the main content and configured
      # through the :as option when configuring your index
      autoload :Table,      'active_admin/pages/index/table'
      autoload :Blog,       'active_admin/pages/index/blog'
      autoload :Thumbnails, 'active_admin/pages/index/thumbnails'
      autoload :Block,      'active_admin/pages/index/block'

      def title
        active_admin_config.plural_resource_name
      end

      def config
        index_config || default_index_config
      end

      # Render's the index configuration that was set in the
      # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
      def main_content
        renderer_class = find_index_renderer_class(config[:as])
        renderer_class.new(self).to_html(config, collection)
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
          ::ActiveAdmin::Pages::Index.const_get(symbol_or_class.to_s.camelcase)
        when Class
          symbol_or_class
        else
          raise ArgumentError, "'as' requires a class or a symbol"
        end
      end

    end
  end
end

