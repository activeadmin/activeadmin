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
      # @param [Array] collection  A "paginated" collection from will_paginate
      # @param [Hash]  options     These options will be passed on to the page_entries_info
      #                            method supplied in will_paginate.
      #                            Useful keys:
      #                             :entry_name - The name to dislpay for this resource collection
      def build(collection, options = {})
        @collection = collection
        div(page_entries_info(@collection, options), :class => "pagination_information")
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
        text_node will_paginate(collection, :previous_label => "Previous", :next_label => "Next")
      end

      # TODO: Refactor to new HTML DSL
      def build_download_format_links(formats = [:csv, :xml, :json])
        links = formats.collect do |format|
          link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format)) 
        end
        text_node ["Download:", links].flatten.join("&nbsp;").html_safe
      end

    end
  end
end
