require 'active_admin/resource_controller/action_builder'
require 'active_admin/resource_controller/data_access'
require 'active_admin/resource_controller/decorators'
require 'active_admin/resource_controller/scoping'
require 'active_admin/resource_controller/streaming'
require 'active_admin/resource_controller/sidebars'
require 'active_admin/resource_controller/resource_class_methods'

module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class ResourceController < BaseController
    layout :determine_active_admin_layout

    respond_to :html, :xml, :json
    respond_to :csv, only: :index

    include ActionBuilder
    include Decorators
    include DataAccess
    include Scoping
    include Streaming
    include Sidebars
    include ViewHelpers::DownloadFormatLinksHelper
    extend  ResourceClassMethods

    def self.active_admin_config=(config)
      if @active_admin_config = config
        defaults resource_class: config.resource_class,
                 route_prefix:   config.route_prefix,
                 instance_name:  config.resource_name.singular
      end
    end

    # Inherited Resources uses the `self.inherited(base)` hook to add
    # in `self.resource_class`. To override it, we need to install
    # our resource_class method each time we're inherited from.
    def self.inherited(base)
      super(base)
      base.override_resource_class_methods!
    end

    private

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      active_admin_namespace.view_factory["#{action}_page"]
    end

    helper_method :renderer_for

    def restrict_format_access!
      unless request.format.html?
        presenter = active_admin_config.get_page_presenter(:index)
        download_formats = (presenter || {}).fetch(:download_links, active_admin_config.namespace.download_links)
        unless build_download_formats(download_formats).include?(request.format.symbol)
          raise ActiveAdmin::AccessDenied.new(current_active_admin_user, :index)
        end
      end
    end

    before_action :restrict_format_access!, only: [:index, :show]
  end
end
