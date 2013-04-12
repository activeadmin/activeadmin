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
      #   eg: auto_link(@post, "My Link Content")
      #
      def auto_link(resource, link_content = nil)
        content = link_content || display_name(resource)
        if (registration = active_admin_resource_for(resource.class))
          begin
            content = link_to(content, registration.route_instance_path(resource))
          rescue
            # ignored
          end
        end
        content
      end

      # Returns the ActiveAdmin::Resource instance for a class
      def active_admin_resource_for(klass)
        return nil unless respond_to?(:active_admin_namespace)
        active_admin_namespace.resource_for(klass)
      end

    end
  end
end
