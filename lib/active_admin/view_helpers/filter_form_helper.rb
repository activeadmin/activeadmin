module ActiveAdmin

  module ViewHelpers
    module FilterFormHelper

      # Helper method to render a filter form
      def active_admin_filters_form_for(search, filters, options = {})
        options[:builder] ||= ActiveAdmin::FilterFormBuilder
        options[:url] ||= collection_path
        options[:html] ||= {}
        options[:html][:method] = :get
        options[:html][:class] ||= "filter_form"
        options[:as] = :q
        clear_link = link_to(I18n.t('active_admin.clear_filters'), "#", :class => "clear_filters_btn")
        form_for search, options do |f|
          filters.each do |filter_options|
            filter_options = filter_options.dup
            attribute = filter_options.delete(:attribute)
            f.filter attribute, filter_options
          end

          buttons = content_tag :div, :class => "buttons" do
            f.submit(I18n.t('active_admin.filter')) +
              clear_link +
              hidden_field_tag("order", params[:order]) +
              hidden_field_tag("scope", params[:scope])
          end

          f.form_buffers.last + buttons
        end
      end

    end
  end

end
