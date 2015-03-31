module ActiveAdmin
  class ExceptionController < ActionController::Base

    def self.included(base)
      base.send :include, Rails.application.routes.url_helpers
    end

    helper ::ActiveAdmin::ViewHelpers

    def self.call(env)
      response = action(:index)
      response.call(env)
    end

    def index
      render status: status
    end

    def active_admin_application
      ActiveAdmin.application
    end

    helper_method :active_admin_application

    def active_admin_namespace
      namespace = active_admin_application.default_namespace
      active_admin_application.namespace(namespace)
    end

    helper_method :active_admin_namespace

    def active_admin_config
      ::ActiveAdmin::Page.new(active_admin_namespace, "Error", {})
    end

    helper_method :active_admin_config

    def current_menu
      active_admin_config.navigation_menu
    end

    helper_method :current_menu

    def env
      request.env
    end

    helper_method :env

    def authorized?(*)
      true
    end

    helper_method :authorized?

    def current_active_admin_user
      if active_admin_namespace.current_user_method
        send(active_admin_namespace.current_user_method)
      end
    end

    helper_method :current_active_admin_user

    def current_active_admin_user?
      !!current_active_admin_user
    end

    helper_method :current_active_admin_user?

    def status
      request.env['STATUS']
    end

    helper_method :status
  end
end
