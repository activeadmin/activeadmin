module ActiveAdmin
  module Views

    # Wraps the content with pagination and available formats.
    #
    # *Example:*
    #
    #   paginated_collection collection, :entry_name => "Post" do
    #     div do
    #       h2 "Inside the
    #     end
    #   end
    #
    # This will create a div with a sentence describing the number of
    # posts in one of the following formats:
    #
    # * "No Posts found"
    # * "Displaying all 10 Posts"
    # * "Displaying Posts 1 - 30 of 31 in total"
    #
    # It will also generate pagination links.
    #
    class PaginatedCollection < ActiveAdmin::Component
      builder_method :paginated_collection


      # Builds a new paginated collection component
      #
      # @param [Array] collection  A "paginated" collection from kaminari
      # @param [Hash]  options     These options will be passed on to the page_entries_info
      #                            method.
      #                            Useful keys:
      #                             :entry_name - The name to display for this resource collection
      def build(collection, options = {})
        @collection = collection
        div(page_entries_info(options).html_safe, :class => "pagination_information")
        @contents = div(:class => "paginated_collection_contents")
        build_pagination_with_formats
        @built = true
      end

      # Override add_child to insert all children into the @contents div
      def add_child(*args, &block)
        if @built
          @contents.add_child(*args, &block)
        else
          super
        end
      end

      protected

      def build_pagination_with_formats
        div :id => "index_footer" do
          build_download_format_links
          build_pagination
        end
      end

      def build_pagination
        text_node paginate(collection)
      end

      # TODO: Refactor to new HTML DSL
      def build_download_format_links(formats = [:csv, :xml, :json])
        links = formats.collect do |format|
          link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
        end
        text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
      end

      # modified from will_paginate
      def page_entries_info(options = {})
        entry_name = options[:entry_name] ||
          (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))

        if collection.num_pages < 2
          case collection.size
          when 0; "No #{entry_name.pluralize} found"
          when 1; "Displaying <b>1</b> #{entry_name}"
          else;   "Displaying <b>all #{collection.size}</b> #{entry_name.pluralize}"
          end
        else
          offset = collection.current_page * ActiveAdmin.default_per_page
          total  = collection.total_count
          %{Displaying #{entry_name.pluralize} <b>%d&nbsp;-&nbsp;%d</b> of <b>%d</b> in total} % [
            offset - ActiveAdmin.default_per_page + 1,
            offset > total ? total : offset,
            total
          ]
        end
      end

    end
  end
end

