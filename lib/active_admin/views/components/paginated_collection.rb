require 'active_admin/helpers/collection'

module ActiveAdmin
  module Views

    # Wraps the content with pagination and available formats.
    #
    # *Example:*
    #
    #   paginated_collection collection, entry_name: "Post" do
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
      # collection => A paginated collection from kaminari
      # options    => These options will be passed to `page_entries_info`
      #   entry_name     => The name to display for this resource collection
      #   params         => Extra parameters for pagination (e.g. { anchor: 'details' })
      #   param_name     => Parameter name for page number in the links (:page by default)
      #   download_links => Download links override (false or [:csv, :pdf])
      #
      def build(collection, options = {})
        @collection     = collection
        @params         = options.delete(:params)
        @param_name     = options.delete(:param_name)
        @download_links = options.delete(:download_links)
        @display_total  = options.delete(:pagination_total) { true }
        @per_page       = options.delete(:per_page)

        unless collection.respond_to?(:num_pages)
          raise(StandardError, "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection.")
        end

        @contents = div(class: "paginated_collection_contents")
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
        div id: "index_footer" do
          build_per_page_select if @per_page.is_a?(Array)
          build_pagination
          div(page_entries_info(options).html_safe, class: "pagination_information")

          download_links = @download_links.is_a?(Proc) ? instance_exec(&@download_links) : @download_links

          if download_links.is_a?(Array) && !download_links.empty?
            build_download_format_links download_links
          else
            build_download_format_links unless download_links == false
          end
        end
      end

      def build_per_page_select
        div class: "pagination_per_page" do
          text_node "Per page:"
          select do
            @per_page.each do |per_page|
              option(
                per_page,
                value: per_page,
                selected: collection.limit_value == per_page ? "selected" : nil
              )
            end
          end
        end
      end

      def build_pagination
        options = {}
        options[:params]     = @params     if @params
        options[:param_name] = @param_name if @param_name

        if !@display_total
          # The #paginate method in kaminari will query the resource with a
          # count(*) to determine how many pages there should be unless
          # you pass in the :total_pages option. We issue a query to determine
          # if there is another page or not, but the limit/offset make this
          # query fast.
          offset = collection.offset(collection.current_page * @per_page.to_i).limit(1).count
          options[:total_pages] = collection.current_page + offset
          options[:right] = 0
        end

        text_node paginate collection, options
      end

      include ::ActiveAdmin::Helpers::Collection
      include ::ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper

      # modified from will_paginate
      def page_entries_info(options = {})
        if options[:entry_name]
          entry_name   = options[:entry_name]
          entries_name = options[:entries_name] || entry_name.pluralize
        elsif collection_is_empty?
          entry_name   = I18n.t "active_admin.pagination.entry", count: 1, default: 'entry'
          entries_name = I18n.t "active_admin.pagination.entry", count: 2, default: 'entries'
        else
          key = "activerecord.models." + collection.first.class.model_name.i18n_key.to_s
          entry_name   = I18n.translate key, count: 1,               default: collection.first.class.name.underscore.sub('_', ' ')
          entries_name = I18n.translate key, count: collection.size, default: entry_name.pluralize
        end

        if @display_total
          if collection.num_pages < 2
            case collection_size
            when 0; I18n.t("active_admin.pagination.empty",    model: entries_name)
            when 1; I18n.t("active_admin.pagination.one",      model: entry_name)
            else;   I18n.t("active_admin.pagination.one_page", model: entries_name, n: collection.total_count)
            end
          else
            offset = (collection.current_page - 1) * collection.limit_value
            total  = collection.total_count
            I18n.t "active_admin.pagination.multiple",
                   model: entries_name,
                   total: total,
                   from: offset + 1,
                   to: offset + collection_size
          end
        else
          # Do not display total count, in order to prevent a `SELECT count(*)`.
          # To do so we must not call `collection.num_pages`
          offset = (collection.current_page - 1) * collection.limit_value
          I18n.t "active_admin.pagination.multiple_without_total",
                 model: entries_name,
                 from: offset + 1,
                 to: offset + collection_size
        end
      end

    end
  end
end
