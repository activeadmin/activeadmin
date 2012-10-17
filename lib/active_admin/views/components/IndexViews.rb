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
        p "!!! in #build_index_view"
        p index_view_class.name
        #need the name
        #need the assets
        #need to create the url
        # li :class => classes_for_index_view(index_view_class) do
        #   a :href => url_for(params.merge(:as => type.to_)) do
        #     text_node "hello"
        #   end
        # end
      end

      def classes_for_index_view(index_view)
      end

		end
	end
end