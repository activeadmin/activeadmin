require 'inherited_resources'

require 'active_admin/base_controller/authorization'
require 'active_admin/base_controller/menu'

module ActiveAdmin
  # BaseController for ActiveAdmin. 
  # It implements ActiveAdmin controllers core features.
  class BaseController < ::InheritedResources::Base
    helper ::ActiveAdmin::ViewHelpers

    layout :determine_active_admin_layout

    before_filter :only_render_implemented_actions
    before_filter :authenticate_active_admin_user

    class << self
      # Ensure that this method is available for the DSL
      public :actions

      # Reference to the Resource object which initialized
      # this controller
      attr_accessor :active_admin_config
    end

    # By default Rails will render un-implemented actions when the view exists. Becuase Active
    # Admin allows you to not render any of the actions by using the #actions method, we need
    # to check if they are implemented.
    def only_render_implemented_actions
      raise AbstractController::ActionNotFound unless action_methods.include?(params[:action])
    end

    include Menu
    include Authorization

    private

    # Calls the authentication method as defined in ActiveAdmin.authentication_method
    def authenticate_active_admin_user
      send(active_admin_namespace.authentication_method) if active_admin_namespace.authentication_method
    end

    def current_active_admin_user
      send(active_admin_namespace.current_user_method) if active_admin_namespace.current_user_method
    end
    helper_method :current_active_admin_user

    def current_active_admin_user?
      !current_active_admin_user.nil?
    end
    helper_method :current_active_admin_user?

    def active_admin_config
      self.class.active_admin_config
    end
    helper_method :active_admin_config

    def active_admin_namespace
      active_admin_config.namespace
    end
    helper_method :active_admin_namespace


    ACTIVE_ADMIN_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]

    # Determine which layout to use.
    #
    #   1.  If we're rendering a standard Active Admin action, we want layout(false)
    #       because these actions are subclasses of the Base page (which implements
    #       all the required layout code)
    #   2.  If we're rendering a custom action, we'll use the active_admin layout so
    #       that users can render any template inside Active Admin.
    def determine_active_admin_layout
      ACTIVE_ADMIN_ACTIONS.include?(params[:action].to_sym) ? false : 'active_admin'
    end

  end
end
