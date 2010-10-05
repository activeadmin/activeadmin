require 'inherited_views'
require 'active_admin/pages'
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
  class ResourceController < ::InheritedViews::Base

    include ActiveAdmin::ActionItems

    include Actions
    include ActionBuilder
    include Callbacks
    include Collection
    include Filters
    include Form
    include Menu
    include PageConfigurations
    include Scoping
    include Sidebars

    # Add our views to the view path
    ActionController::Base.append_view_path File.expand_path('../views', __FILE__)
    self.default_views = 'active_admin_default'
    
    helper ::ActiveAdmin::ViewHelpers

    layout 'active_admin'
    
    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    class << self

      # Reference to the Resource object which initialized
      # this controller
      attr_accessor :active_admin_config
      
      def active_admin_config=(config)
        @active_admin_config = config
        defaults :resource_class => config.resource
      end

      # By default Admin Notes are on for all registered models
      # To turn off admin notes for a specific model pass false to admin_notes 
      # method in the registration block
      #
      # Eg:
      #
      #   ActiveAdmin.register Post do
      #     admin_notes false
      #   end
      #
      def admin_notes(true_or_false)
        active_admin_config.admin_notes = true_or_false
      end


      def belongs_to(target, options = {})
        active_admin_config.belongs_to = Resource::BelongsTo.new(active_admin_config, target, options)
        super(target, options.dup)
      end
     
    end

    # Default Sidebar Sections
    sidebar :filters, :only => :index do
      active_admin_filters_form_for @search, filters_config
    end

    # Default Action Item Links
    action_item :only => :show do
      if controller.action_methods.include?('edit')
        link_to "Edit #{active_admin_config.resource_name}", edit_resource_path(resource)
      end
    end

    action_item :only => :show do
      if controller.action_methods.include?("destroy")
        link_to "Delete #{active_admin_config.resource_name}",
          resource_path(resource), 
          :method => :delete, :confirm => "Are you sure you want to delete this?"
      end
    end

    action_item :except => [:new, :show] do
      if controller.action_methods.include?('new')
        link_to "+ New #{active_admin_config.resource_name}", new_resource_path
      end
    end

    protected

    def active_admin_config
      self.class.active_admin_config
    end
    helper_method :active_admin_config

    def index_config
      @index_config ||= self.class.index_config
    end
    helper_method :index_config

    def show_config
      @show_config ||= self.class.show_config
    end
    helper_method :show_config

    # Returns the renderer class to use for the given action.
    #
    # TODO: This needs to be wrapped into a default config as well
    # as overrideable on each controller
    def renderer_for(action)
      {
        :index  => ::ActiveAdmin::Pages::Index,
        :new    => ::ActiveAdmin::Pages::New,
        :show   => ::ActiveAdmin::Pages::Show,
        :edit   => ::ActiveAdmin::Pages::Edit
      }[action]
    end
    helper_method :renderer_for

  end
end
