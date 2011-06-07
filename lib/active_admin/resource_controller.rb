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
require 'active_admin/resource_controller/sidebars'

module ActiveAdmin
  class ResourceController < ::InheritedResources::Base

    helper ::ActiveAdmin::ViewHelpers

    layout false

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    before_filter :only_render_implemented_actions
    before_filter :authenticate_active_admin_user

    include Actions
    include ActiveAdmin::ActionItems
    include ActionBuilder
    include Callbacks
    include Collection
    include Filters
    include Form
    include Menu
    include PageConfigurations
    include Scoping
    include Sidebars

    class << self

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

    # Default Sidebar Sections
    sidebar :filters, :only => :index do
      active_admin_filters_form_for assigns["search"], filters_config
    end

    # Default Action Item Links
    action_item :only => :show do
      if controller.action_methods.include?('edit')
        link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
      end
    end

    action_item :only => :show do
      if controller.action_methods.include?("destroy")
        link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name),
          resource_path(resource),
          :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
      end
    end

    action_item :except => [:new, :show] do
      if controller.action_methods.include?('new')
        link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
      end
    end

    protected

    # By default Rails will render un-implemented actions when the view exists. Becuase Active
    # Admin allows you to not render any of the actions by using the #actions method, we need
    # to check if they are implemented.
    def only_render_implemented_actions
      raise AbstractController::ActionNotFound unless action_methods.include?(params[:action])
    end

    # Calls the authentication method as defined in ActiveAdmin.authentication_method
    def authenticate_active_admin_user
      send(ActiveAdmin.authentication_method) if ActiveAdmin.authentication_method
    end

    def current_active_admin_user
      send(ActiveAdmin.current_user_method) if ActiveAdmin.current_user_method
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

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      ActiveAdmin.view_factory["#{action}_page"]
    end
    helper_method :renderer_for
  end
end
