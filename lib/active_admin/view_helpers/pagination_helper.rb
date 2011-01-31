module ActiveAdmin
  module ViewHelpers
    module PaginationHelper

      def pagination_information(collection, options = {})
        content_tag :div, page_entries_info(collection, options), :class => "pagination_information"
      end

      def download_format_links(formats = [:csv, :xml, :json])
        links = formats.collect do |format|
          link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format)) 
        end
        ["Download:", links].flatten.join("&nbsp;").html_safe
      end

      def pagination(collection)
        will_paginate collection, :previous_label => "Previous", :next_label => "Next"
      end

      def pagination_with_formats(collection)
        content_tag :div, [download_format_links, pagination(collection)].join(" ").html_safe, :id => "index_footer"
      end

      def wrap_with_pagination(collection, options = {}, &block)
        pagination_information(collection, options) + capture(&block) + pagination_with_formats(collection)
      end

    end
  end
end
