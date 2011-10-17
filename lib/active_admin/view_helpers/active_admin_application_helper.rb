module ActiveAdmin
  module ViewHelpers
    module ActiveAdminApplicationHelper

      # Returns the current Active Admin application instance
      def active_admin_application
        ActiveAdmin.application
      end

      def authorized?(*args)
        ActiveAdmin.application.authorization_adapter.authorized?(*args)
      end

      # only generates links to actions the user is authorized for. by
      # default, it uses resource_path/edit_resource_path/etc for the route.
      # by passing the :path param, it's possible to link elsewhere
      #
      # expected arguments: action (:view), link name ('Go Here'), resource
      def authorized_link_to(*args)
        options = args.extract_options!

        action = args[0]
        name = args[1]
        resource = args[2]

        link_path = options[:path] ||= default_authorized_path(resource, action)

        if authorized?(:current_user => send(ActiveAdmin.application.current_user_method), :resource => resource, :action => action)
          link_to name, link_path, default_authorized_options(action), options
        elsif options[:display_if_false]
          name
        end

      end

      def default_authorized_path(resource, action)

        case action
        when :update
          edit_resource_path(resource)
        when :create
          new_resource_path
        else
          resource_path(resource)
        end

      end

      def default_authorized_options(action)

        case action
        when :delete
          {
            :method => :delete,
            :confirm => I18n.t('active_admin.delete_confirmation')
          }
        else
          {}
        end

      end

      def view_link_to(*args)
        authorized_link_to(:read, *args)
      end

      def edit_link_to(*args)
        authorized_link_to(:update, *args)
      end

      def delete_link_to(*args)
        authorized_link_to(:destroy, *args)
      end

      def new_link_to(*args)
        authorized_link_to(:create, *args)
      end

    end
  end
end
