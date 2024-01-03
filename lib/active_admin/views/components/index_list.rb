# frozen_string_literal: true
module ActiveAdmin
  module Views
    # Renders a collection of index views available to the resource
    # as a list with a separator
    class IndexList < ActiveAdmin::Component
      def tag_name
        "div"
      end

      # Builds the links for presenting different index views to the user
      #
      # @param [Array] index_classes The class constants that represent index page presenters
      def build(index_classes)
        add_class "index-button-group index-list"
        unless current_filter_search_empty?
          index_classes.each do |index_class|
            build_index_list(index_class)
          end
        end
      end

      protected

      # Builds the individual link and HTML classes for each index page presenter
      #
      # @param [Class] index_class The class on which to build the link and html classes
      def build_index_list(index_class)
        params = request.query_parameters.except :page, :commit, :format
        url_with_params = url_for(**params.merge(as: index_class.index_name.to_sym).symbolize_keys)

        a href: url_with_params, class: classes_for_index(index_class) do
          name = index_class.index_name
          I18n.t("active_admin.index_list.#{name}", default: name.to_s.titleize)
        end
      end

      def classes_for_index(index_class)
        classes = ["index-button"]
        classes << "index-button-selected" if current_index?(index_class)
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
        params.include?(:q) && collection_empty?
      end
    end
  end
end
