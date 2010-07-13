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

      # Default Index config styles. Each of these are what 
      # actually gets rendered in the main content and configured
      # through the :as option when configuring your index
      autoload :Table,      'active_admin/pages/index/table'
      autoload :Posts,      'active_admin/pages/index/posts'
      autoload :Thumbnails, 'active_admin/pages/index/thumbnails'

    end
  end
end

