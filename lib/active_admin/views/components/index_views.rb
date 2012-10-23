require 'active_admin/helpers/collection'

module ActiveAdmin
	module Views

    # Renders a collection of index view available to the resource
    # as a list with a separator
		class IndexViews < ActiveAdmin::Component
      builder_method :index_views_renderer

      def tag_name
        'ul'
      end

      def build(index_classes)
        index_classes.each do |index_view_class|
          build_index_view(index_view_class)
        end
      end

      protected

      def build_index_view(index_view_class)
        #need the assets
        #need to create the url
        li do
          a :href => url_for(params.merge(:as => index_view_class.index_name)) do
            text_node "#{index_view_class.index_name}"
          end
        end
      end

		end
	end
end