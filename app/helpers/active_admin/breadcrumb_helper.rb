# frozen_string_literal: true
module ActiveAdmin
  module BreadcrumbHelper
    ID_FORMAT_REGEXP = /\A(\d+|[a-f0-9]{24}|(?:[a-f0-9]{8}-(?:[a-f0-9]{4}-){3}[a-f0-9]{12}))\z/.freeze

    # Returns an array of links to use in a breadcrumb
    def build_breadcrumb_links(path = request.path, html_options = {})
      config = active_admin_config.breadcrumb
      if config.is_a?(Proc)
        instance_exec(controller, &config)
      elsif config.present?
        default_breadcrumb_links(path, html_options)
      end
    end

    def default_breadcrumb_links(path, html_options = {})
      # remove leading "/" and split up the URL
      # and remove last since it's used as the page title
      parts = path.split("/").select(&:present?)[0..-2]

      parts.each_with_index.map do |part, index|
        # 1. try using `display_name` if we can locate a DB object
        # 2. try using the model name translation
        # 3. default to calling `titlecase` on the URL fragment
        if ID_FORMAT_REGEXP.match?(part) && parts[index - 1]
          parent = active_admin_config.belongs_to_config.try :target
          config = parent && parent.resource_name.route_key == parts[index - 1] ? parent : active_admin_config
          name = display_name config.find_resource part
        end
        name ||= I18n.t "activerecord.models.#{part.singularize}", count: 2.1, default: part.titlecase

        # Don't create a link if the resource's show action is disabled
        if !config || config.defined_actions.include?(:show)
          link_to name, "/" + parts[0..index].join("/"), html_options
        else
          name
        end
      end
    end
  end
end
