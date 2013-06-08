module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper

      # Returns an array of links to use in a breadcrumb
      def breadcrumb_links(path = request.path)
        parts = path[1..-1].split('/') # remove leading "/" and split up the URL
        parts.pop                      # remove last since it's used as the page title

        parts.each_with_index.map do |part, index|
          # 1. try using `display_name` if we can locate a DB object
          # 2. try using the model name translation
          # 3. default to calling `titlecase` on the URL fragment
          if part =~ /\A(\d+|[a-f0-9]{24})\z/ && parts[index-1]
            config = active_admin_config.belongs_to_config.try(:target) || active_admin_config
            obj    = config.resource_class.where( config.resource_class.primary_key => part ).first
            name   = display_name obj
          end
          name ||= I18n.t "activerecord.models.#{part.singularize}", :count => 1.1, :default => part.titlecase

          link_to name, '/' + parts[0..index].join('/')
        end
      end

    end
  end
end
