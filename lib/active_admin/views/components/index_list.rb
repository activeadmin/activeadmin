require 'active_admin/helpers/collection'

module ActiveAdmin
	module Views

    # Renders a collection of index view available to the resource
    # as a list with a separator
		class IndexList < ActiveAdmin::Component
      builder_method :index_list_renderer

      include ::ActiveAdmin::Helpers::Collection

      def default_class_name
        "indexes table_tools_segmented_control"
      end

      def tag_name
        'ul'
      end

      def build(index_classes)
        unless current_filter_search_empty?
          index_classes.each do |index_class|
            build_index_list(index_class)
          end
        end
      end

      protected

      def build_index_list(index_class)
        li :class => classes_for_index(index_class) do
          a :href => url_for(params.merge(:as => index_class.index_name.to_sym)), :class => "table_tools_button" do
            name = index_class.index_name
            t("active_admin.index_list.#{name}", :default => name.to_s.titleize)
          end
        end
      end

      def classes_for_index(index_class)
        classes = ["index"]
        classes << "selected" if current_index?(index_class)
        classes.join(" ")
      end

      def current_index?(index_class)
        if params[:as]
          params[:as] == index_class.index_name
        else
          active_admin_config.default_index_class == index_class
        end
      end

      def current_filter_search_empty?
        params.include?(:q) && collection_is_empty?
      end

		end
	end
end


