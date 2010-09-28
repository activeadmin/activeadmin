module ActiveAdmin
  module ViewHelpers
    module FilterFormHelper

      def active_admin_filters_form_for(search, filters, options = {})
        options[:builder] ||= ActiveAdmin::Filters::FormBuilder
        options[:url] ||= collection_path
        options[:html] ||= {}
        options[:html][:method] = :get
        options[:as] = :q
        clear_link = link_to("Clear Filters", "#", :class => "clear_filters_btn")
        form_for search, options do |f|
          filters.each do |filter_options|
            filter_options = filter_options.dup
            attribute = filter_options.delete(:attribute)
            f.filter attribute, filter_options
          end
          f.form_buffers.last +
            f.submit("Filter") + 
            clear_link + 
            hidden_field_tag("order", params[:order])
        end
      end

    end
  end
end
