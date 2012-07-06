module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper

      # Returns an array of links to use in a breadcrumb
      def breadcrumb_links(path = nil)
        path ||= request.fullpath
        parts = path.gsub(/^\//, '').split('/')
        parts.pop unless %w{ create update }.include?(params[:action])
        crumbs = []
        parts.each_with_index do |part, index|
          name = nil

          if part =~ /^\d|^[a-f0-9]{24}$/
            config = if active_admin_config.belongs_to? && index <= 2
              active_admin_config.belongs_to_config.target
            else
              active_admin_config
            end
            # Rescue in case the part of the path was misidentified as an ID.
            id = part[/^[a-f0-9]{24}$/] ? part : part.to_i
            name = display_name(config.resource_class.find(id)) rescue nil
          end

          name ||= begin
            I18n.translate!("activerecord.models.#{part.singularize}", :count => 1.1)
          rescue I18n::MissingTranslationData
            part.titlecase
          end

          crumbs << link_to(name, '/' + parts[0..index].join('/'))
        end
        crumbs
      end
    end
  end
end
