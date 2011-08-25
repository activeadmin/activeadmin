require 'inherited_resources'
require 'active_admin/resource_controller/actions'
require 'active_admin/resource_controller/action_builder'
require 'active_admin/resource_controller/callbacks'
require 'active_admin/resource_controller/collection'
require 'active_admin/resource_controller/filters'
require 'active_admin/resource_controller/form'
require 'active_admin/resource_controller/menu'
require 'active_admin/resource_controller/page_configurations'
require 'active_admin/resource_controller/scoping'

module ActiveAdmin
  class ResourceController < ::InheritedResources::Base

    helper ::ActiveAdmin::ViewHelpers

    layout :determine_active_admin_layout

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    before_filter :only_render_implemented_actions
    before_filter :authenticate_active_admin_user

    ACTIVE_ADMIN_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]

    include Actions
    include ActionBuilder
    include Callbacks
    include Collection
    include Filters
    include Form
    include Menu
    include PageConfigurations
    include Scoping

    class << self
      # Ensure that this method is available for the DSL
      public :actions

      # Reference to the Resource object which initialized
      # this controller
      attr_accessor :active_admin_config

      def active_admin_config=(config)
        @active_admin_config = config
        defaults  :resource_class => config.resource,
                  :route_prefix => config.route_prefix,
                  :instance_name => config.underscored_resource_name
      end

      public :belongs_to
    end

    protected

    # By default Rails will render un-implemented actions when the view exists. Becuase Active
    # Admin allows you to not render any of the actions by using the #actions method, we need
    # to check if they are implemented.
    def only_render_implemented_actions
      raise AbstractController::ActionNotFound unless action_methods.include?(params[:action])
    end

    # Determine which layout to use.
    #
    #   1.  If we're rendering a standard Active Admin action, we want layout(false)
    #       because these actions are subclasses of the Base page (which implementes
    #       all the required layout code)
    #   2.  If we're rendering a custom action, we'll use the active_admin layout so
    #       that users can render any template inside Active Admin.
    def determine_active_admin_layout
      ACTIVE_ADMIN_ACTIONS.include?(params[:action].to_sym) ? false : 'active_admin'
    end

    # Calls the authentication method as defined in ActiveAdmin.authentication_method
    def authenticate_active_admin_user
      send(active_admin_application.authentication_method) if active_admin_application.authentication_method
    end

    def current_active_admin_user
      send(active_admin_application.current_user_method) if active_admin_application.current_user_method
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

    def active_admin_application
      ActiveAdmin.application
    end

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      active_admin_application.view_factory["#{action}_page"]
    end
    helper_method :renderer_for
  end
end
