module ActiveAdmin

  # Exception class to raise when there is an authorized access
  # exception thrown. The exception has a few goodies that may
  # be useful for capturing / recognizing security issues.
  class AccessDenied < StandardError
    attr_reader :user, :action, :subject

    def initialize(user, action, subject)
      @user, @action, @subject = user, action, subject

      super()
    end

    def message
      I18n.t("active_admin.access_denied.message")
    end
  end


  class BaseController < ::InheritedResources::Base
    module Authorization
      include MethodOrProcHelper
      extend ActiveSupport::Concern

      ACTIONS_DICTIONARY = {
        :index   => ActiveAdmin::Authorization::READ,
        :show    => ActiveAdmin::Authorization::READ,
        :new     => ActiveAdmin::Authorization::CREATE,
        :create  => ActiveAdmin::Authorization::CREATE,
        :edit    => ActiveAdmin::Authorization::UPDATE,
        :update  => ActiveAdmin::Authorization::UPDATE,
        :destroy => ActiveAdmin::Authorization::DESTROY
      }

      included do
        rescue_from ActiveAdmin::AccessDenied, :with => :dispatch_active_admin_access_denied

        helper_method :authorized?
        helper_method :authorize!
      end

      protected

      # Authorize the action and subject. Available in the controller
      # as well as all the views.
      #
      # @param [Symbol] action The action to check if the user has permission
      #                 to perform on the subject.
      #
      # @param [any] subject The subject that the user is trying to perform
      #                 the action on.
      #
      # @returns [Boolean]
      #
      def authorized?(action, subject = nil)
        active_admin_authorization.authorized?(action, subject)
      end


      # Authorize the action and subject. Available in the controller
      # as well as all the views. If the action is not allowd, it raises
      # an ActiveAdmin::AccessDenied exception.
      #
      # @param [Symbol] action The action to check if the user has permission
      #                 to perform on the subject.
      #
      # @param [any] subject The subject that the user is trying to perform
      #                 the action on.
      #
      # @returns [Boolean] True if authorized, otherwise raises
      #                 an ActiveAdmin::AccessDenied.
      def authorize!(action, subject = nil)
        unless authorized? action, subject
          raise ActiveAdmin::AccessDenied.new(current_active_admin_user,
                                              action,
                                              subject)
        end
      end

      # Performs authorization on the resource using the current controller
      # action as the permission action.
      #
      def authorize_resource!(resource)
        permission = action_to_permission(params[:action])
        authorize! permission, resource
      end

      # Retrieve or instantiate the authorization instance for this resource
      #
      # @returns [ActiveAdmin::AuthorizationAdapter]
      def active_admin_authorization
        @active_admin_authorization ||= active_admin_authorization_adapter.new(active_admin_config, current_active_admin_user)
      end

      # Returns the class to be used as the authorization adapter
      #
      # @returns [Class]
      def active_admin_authorization_adapter
        if active_admin_namespace.authorization_adapter.is_a?(String)
          ActiveSupport::Dependencies.constantize(active_admin_namespace.authorization_adapter)
        else
          active_admin_namespace.authorization_adapter
        end
      end

      # Converts a controller action into one of the correct Active Admin
      # authorization names. Uses the ACTIONS_DICTIONARY to convert the
      # action name to permission.
      #
      # @param [String, Symbol] action The controller action name.
      #
      # @returns [Symbol] The permission name to use.
      def action_to_permission(action)
        return nil unless action

        action = action.to_sym

        if Authorization::ACTIONS_DICTIONARY.has_key?(action)
          Authorization::ACTIONS_DICTIONARY[action]
        else
          action
        end
      end

      def dispatch_active_admin_access_denied(exception)
        call_method_or_exec_proc active_admin_namespace.on_unauthorized_access, exception
      end

      def rescue_active_admin_access_denied(exception)
        error_message = exception.message

        respond_to do |format|
          format.html do
            flash[:error] = error_message

            if request.headers.key?("HTTP_REFERER")
              redirect_to :back
            else
              controller, action = active_admin_namespace.root_to.split("#")
              redirect_to :controller => controller, :action => action
            end
          end

          format.csv { render :text => error_message, :status => :unauthorized}
          format.json { render :json => { :error => error_message }, :status => :unauthorized}
          format.xml { render :xml => "<error>#{error_message}</error>", :status => :unauthorized}
        end
      end

    end
  end
end
