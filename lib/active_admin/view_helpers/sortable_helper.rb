module ActiveAdmin
  module ViewHelpers
    module SortableHelper

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
    
    end
  end
end
