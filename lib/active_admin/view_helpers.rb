module ActiveAdmin
  module ViewHelpers
    
    def breadcrumb(separator = "&rsaquo;")
      html_safe_or_string @breadcrumbs.map { |txt, path| link_to_unless((path.blank? || current_page?(path)), h(txt), path) }.join(" #{separator} ")
    end

    # Returns an array for the current sort order
    #   current_sort[0] #=> sort_key
    #   current_sort[1] #=> asc | desc
    def current_sort
      @current_sort ||= if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        [$1,$2]
      else
        []
      end
    end

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

    # Returns the order to use for a given sort key
    # 
    # Default is to use 'desc'. If the current sort key is
    # 'desc' it will return 'asc'
    def order_for_sort_key(sort_key)
      current_key, current_order = current_sort
      return 'desc' unless current_key == sort_key
      current_order == 'desc' ? 'asc' : 'desc'
    end

    def sortable_header_for(text, sort_key)
      # Setup Sortable CSS Classes - .sortable, .sorted-asc, .sorted-desc
      classes = ["sortable"]
      if current_sort[0] == sort_key
        classes << "sorted-#{current_sort[1]}"
      end

      th = "<th class=\"#{classes.join(' ')}\">"
      th << link_to(text, request.query_parameters.merge(:order => "#{sort_key}_#{order_for_sort_key(sort_key)}").except(:page))
      th << "</th>"
    end
    
    def html_safe_or_string(string)
      string.respond_to?(:html_safe) ? string.html_safe : string
    end

    def title(_title)
      @page_title = _title 
    end

    def status_tag(status, options = {})
      options[:class] ||= ""
      options[:class] << ["status", status.downcase].join(' ')
      content_tag :span, status, options
    end

    def active_admin_form_for(resource, options = {}, &block)
      options[:builder] ||= ActiveAdmin::FormBuilder
      semantic_form_for resource, options, &block
    end

    def active_admin_filters_form_for(search, filters, options = {})
      options[:builder] ||= ActiveAdmin::FilterFormBuilder
      options[:url] ||= collection_path
      options[:html] ||= {}
      options[:html][:method] = :get
      options[:as] = :q
      form_for search, options do |f|
        filters.each do |filter_options|
          attribute = filter_options.delete(:attribute)
          f.filter attribute, filter_options
        end
        f.submit("Filter") + hidden_field_tag("order", params[:order])
      end
    end

  end
end
