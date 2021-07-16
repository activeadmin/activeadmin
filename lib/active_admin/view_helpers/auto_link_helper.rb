# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module AutoLinkHelper

      # Automatically links objects to their resource controllers. If
      # the resource has not been registered, a string representation of
      # the object is returned.
      #
      # The default content in the link is returned from ActiveAdmin::ViewHelpers::DisplayHelper#display_name
      #
      # You can pass in the content to display
      #   eg: auto_link(@post, "My Link")
      #
      def auto_link(resource, content = display_name(resource))
        if url = auto_url_for(resource)
          link_to content, url
        else
          content
        end
      end

      # Like `auto_link`, except that it only returns a URL instead of a full <a> tag
      def auto_url_for(resource)
        config = active_admin_resource_for(resource.class)
        return unless config

        if config.controller.action_methods.include?("show") &&
          authorized?(ActiveAdmin::Auth::READ, resource)
          url_for config.route_instance_path resource, url_options
        elsif config.controller.action_methods.include?("edit") &&
          authorized?(ActiveAdmin::Auth::UPDATE, resource)
          url_for config.route_edit_instance_path resource, url_options
        end
      end

      # Returns the ActiveAdmin::Resource instance for a class
      def active_admin_resource_for(klass)
        if respond_to? :active_admin_namespace, true
          active_admin_namespace.resource_for klass
        end
      end

    end
  end
end
