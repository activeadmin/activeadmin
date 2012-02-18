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

      attr_reader :collection

      # Builds a new paginated collection component
      #
      # @param [Array] collection  A "paginated" collection from kaminari
      # @param [Hash]  options     These options will be passed on to the page_entries_info
      #                            method.
      #                            Useful keys:
      #                              :entry_name - The name to display for this resource collection
      #                              :param_name - Parameter name for page number in the links (:page by default)
      #                              :download_links - Set to false to skip download format links
      #                              :unbounded - Don't calculate the total count & total pages
      def build(collection, options = {})
        @collection = collection
        @param_name     = options.delete(:param_name)
        @download_links = options.delete(:download_links)
        @unbounded      = !!options.delete(:unbounded)

        unless collection.respond_to?(:num_pages)
          raise(StandardError, "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection.")
        end

        @contents = div(:class => "paginated_collection_contents")
        build_pagination_with_formats(options)
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

      def build_pagination_with_formats(options)
        div :id => "index_footer" do
          build_pagination
          div(page_entries_info(options).html_safe, :class => "pagination_information")
          build_download_format_links unless @download_links == false
        end
      end

      def build_pagination
        options = request.query_parameters.except(:commit, :format)

        options[:param_name] = @param_name if @param_name
        if @unbounded
          options[:num_pages] = collection.current_page
          # If we are for sure not at the end, pretend like we have one extra page.
          unless collection.size < collection.limit_value
            # Unfortunately, we're not peeking ahead, so this might mean that the next page has
            # zero items in it.  This also means that the Last page link will show up, pointing to
            # the next page; but kaminari doesn't give us the option to hide it.
            options[:num_pages] += 1
          end
        end

        text_node paginate(collection, options.symbolize_keys)
      end

      # TODO: Refactor to new HTML DSL
      def build_download_format_links(formats = [:csv, :xml, :json])
        links = formats.collect do |format|
          link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
        end
        div :class => "download_links" do
		  text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
        end
      end

      # modified from will_paginate
      def page_entries_info(options = {})
        return unbounded_entries_info(options) if @unbounded

        entry_name, entries_name = localized_entry_names(options)

        if collection.num_pages < 2
          case collection.size
          when 0; I18n.t('active_admin.pagination.empty', :model => entries_name)
          when 1; I18n.t('active_admin.pagination.one', :model => entry_name)
          else;   I18n.t('active_admin.pagination.one_page', :model => entries_name, :n => collection.total_count)
          end
        else
          offset = collection.current_page * collection.size
          total  = collection.total_count
          I18n.t('active_admin.pagination.multiple', :model => entries_name, :from => (offset - collection.size + 1), :to => offset > total ? total : offset, :total => total)
        end
      end

      # We avoid all references to collection.num_pages and collection.total_count to avoid performing
      # potentially expensive queries.
      def unbounded_entries_info(options = {})
        entry_name, entries_name = localized_entry_names(options)

        # If we are on the first page and have run out, we can be consistent w/ paged_entries info
        if collection.current_page == 1
          if collection.size == 0
            return I18n.t('active_admin.pagination.empty', :model => entries_name)
          elsif collection.size == 1
            return I18n.t('active_admin.pagination.one', :model => entry_name)
          elsif collection.size < collection.limit_value
            return I18n.t('active_admin.pagination.one_page', :model => entries_name, :n => collection.size)
          end
        end

        # Otherwise, we are unsure of our bounds
        start = (collection.current_page - 1) * collection.limit_value
        I18n.t('active_admin.pagination.multiple_without_total', :model => entries_name, :from => (start + 1), :to => (start + collection.size))
      end

      def localized_entry_names(options)
        if options[:entry_name]
          entry_name = options[:entry_name]
          entries_name = options[:entries_name]
        elsif collection.empty?
          entry_name = I18n.translate("active_admin.pagination.entry", :count => 1, :default => 'entry')
          entries_name = I18n.translate("active_admin.pagination.entry", :count => 2, :default => 'entries')
        else
          begin
            entry_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => 1)
            entries_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => collection.size)
          rescue I18n::MissingTranslationData
            entry_name = collection.first.class.name.underscore.sub('_', ' ')
          end
        end
        entries_name = entry_name.pluralize unless entries_name

        [entry_name, entries_name]
      end

    end
  end
end
