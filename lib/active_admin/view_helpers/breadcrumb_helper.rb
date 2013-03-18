module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper

      # Returns an array of links to use in a breadcrumb
      def breadcrumb_links(path = request.path)
        parts = path[1..-1].split('/')                        # remove leading "/" and split up URL path
        parts.pop unless params[:action] =~ /^create|update$/ # remove last if not create/update

        parts.each_with_index.map do |part, index|
          # If an object (users/23), look it up via ActiveRecord and capture its name.
          # If name is nil, look up the model translation, using `titlecase` as the backup.
          if part =~ /^\d|^[a-f0-9]{24}$/ && parent = parts[index-1]
            klass = parent.singularize.camelcase.constantize rescue nil
            obj   = klass.find_by_id(part) if klass
            name  = display_name(obj)      if obj
          end
          name ||= I18n.t "activerecord.models.#{part.singularize}", :count => 1.1, :default => part.titlecase

          link_to name, '/' + parts[0..index].join('/')
        end
      end

    end
  end
end
