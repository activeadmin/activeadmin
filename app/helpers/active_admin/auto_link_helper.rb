# frozen_string_literal: true
module ActiveAdmin
  module AutoLinkHelper
    # Automatically links objects to their resource controllers. If
    # the resource has not been registered, a string representation of
    # the object is returned.
    #
    # The default content in the link is returned from ActiveAdmin::DisplayHelper#display_name
    #
    # You can pass in the content to display
    #   eg: auto_link(@post, "My Link")
    #
    def auto_link(resource, content = display_name(resource), **html_options)
      if url = auto_url_for(resource)
        link_to content, url, html_options
      else
        content
      end
    end

    # Like `auto_link`, except that it only returns a URL for the resource
    def auto_url_for(resource)
      config = active_admin_resource_for(resource.class)
      return unless config

      if config.controller.action_methods.include?("show") &&
        authorized?(ActiveAdmin::Auth::READ, resource)
        url_for config.route_instance_path resource, url_options
      elsif config.controller.action_methods.include?("edit") &&
        authorized?(ActiveAdmin::Auth::EDIT, resource)
        url_for config.route_edit_instance_path resource, url_options
      end
    end

    def new_action_authorized?(resource_or_class)
      controller.action_methods.include?("new") && authorized?(ActiveAdmin::Auth::NEW, resource_or_class)
    end

    def show_action_authorized?(resource_or_class)
      controller.action_methods.include?("show") && authorized?(ActiveAdmin::Auth::READ, resource_or_class)
    end

    def edit_action_authorized?(resource_or_class)
      controller.action_methods.include?("edit") && authorized?(ActiveAdmin::Auth::EDIT, resource_or_class)
    end

    def destroy_action_authorized?(resource_or_class)
      controller.action_methods.include?("destroy") && authorized?(ActiveAdmin::Auth::DESTROY, resource_or_class)
    end

    def auto_logout_link_path
      render_or_call_method_or_proc_on(self, active_admin_namespace.logout_link_path)
    end

    private

    # Returns the ActiveAdmin::Resource instance for a class
    # While `active_admin_namespace` is a helper method, this method seems
    # to exist to otherwise resolve failed component specs using mock_action_view.
    def active_admin_resource_for(klass)
      if respond_to? :active_admin_namespace
        active_admin_namespace.resource_for klass
      end
    end
  end
end
