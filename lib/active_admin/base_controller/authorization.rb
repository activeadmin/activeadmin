module ActiveAdmin

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
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveAdmin::AccessDenied do |exception|
          respond_to do |format|
            format.html do
              flash[:error] = exception.message

              if request.headers.keys.include?("HTTP_REFERER")
                redirect_to :back
              else
                controller, action = active_admin_namespace.root_to.split("#")
                redirect_to :controller => controller, :action => action
              end
            end
          end
        end

        helper_method :authorized?
        helper_method :authorize!
      end

      ACTIONS_DICTIONARY = {
        :index   => ActiveAdmin::Authorization::READ,
        :show    => ActiveAdmin::Authorization::READ,
        :new     => ActiveAdmin::Authorization::CREATE,
        :create  => ActiveAdmin::Authorization::CREATE,
        :edit    => ActiveAdmin::Authorization::UPDATE,
        :update  => ActiveAdmin::Authorization::UPDATE,
        :destroy => ActiveAdmin::Authorization::DESTROY
      }

      protected

      # Retrieve or instantiate the authorization instance for this resource
      #
      # @returns [ActiveAdmin::AuthorizationAdapter]
      def active_admin_authorization
        @active_admin_authorization ||= active_admin_authorization_adapter.new(active_admin_config, current_active_admin_user)
      end

      def active_admin_authorization_adapter
        if active_admin_namespace.authorization_adapter.is_a?(String)
          ActiveSupport::Dependencies.constantize(active_admin_namespace.authorization_adapter)
        else
          active_admin_namespace.authorization_adapter
        end
      end

      def authorized?(action, subject = nil)
        active_admin_authorization.authorized?(action, subject)
      end

      def authorize!(action, subject = nil)
        unless authorized? action, subject
          raise ActiveAdmin::AccessDenied.new(current_active_admin_user, action, subject)
        end
      end

      def authorize_resource!(resource)
        permission = action_to_permission(params[:action])
        authorize! permission, resource
      end

      def action_to_permission(action)
        return nil unless action

        action = action.to_sym

        if Authorization::ACTIONS_DICTIONARY.has_key?(action)
          Authorization::ACTIONS_DICTIONARY[action]
        else
          action
        end
      end


    end

  end
end
