# frozen_string_literal: true
module ActiveAdmin
  # BaseController for ActiveAdmin.
  # It implements ActiveAdmin controllers core features.
  class BaseController < ::InheritedResources::Base
    # Include route helpers with patched url_for for custom namespace support
    include Helpers::Routes::UrlHelpers

    helper MethodOrProcHelper
    helper LayoutHelper
    helper FormHelper
    helper BreadcrumbHelper
    helper AutoLinkHelper
    helper DisplayHelper
    helper IndexHelper

    layout "active_admin"

    before_action :only_render_implemented_actions
    before_action :authenticate_active_admin_user

    class << self
      # Ensure that this method is available for the DSL
      public :actions

      # Reference to the Resource object which initialized
      # this controller
      attr_accessor :active_admin_config
    end

    include BaseController::Authorization
    include BaseController::Menu

    protected

    # Override url_for to use main app's router for hash options.
    # This fixes route generation for custom namespaces in isolated engines.
    # We merge with request.path_parameters to provide the current context
    # (controller, action) when not explicitly specified.
    def url_for(options = nil)
      case options
      when nil
        super
      when Hash
        route_options = options.dup
        # If no controller specified, use current controller for context
        route_options[:controller] ||= request.path_parameters[:controller]
        # If controller is specified without namespace prefix, add it from current controller
        if route_options[:controller] && !route_options[:controller].to_s.include?("/")
          current_controller = request.path_parameters[:controller]
          if current_controller && current_controller.include?("/")
            namespace = current_controller.split("/").first
            route_options[:controller] = "#{namespace}/#{route_options[:controller]}"
          end
        end
        route_options[:only_path] = true unless route_options.key?(:only_path) || route_options.key?(:host)
        Rails.application.routes.url_for(route_options)
      when ActionController::Parameters
        unless options.permitted?
          raise ArgumentError, "Generating a URL from unpermitted parameters is not allowed"
        end
        opts = options.to_h.symbolize_keys
        # If no controller specified, use current controller for context
        opts[:controller] ||= request.path_parameters[:controller]
        # If controller is specified without namespace prefix, add it from current controller
        if opts[:controller] && !opts[:controller].to_s.include?("/")
          current_controller = request.path_parameters[:controller]
          if current_controller && current_controller.include?("/")
            namespace = current_controller.split("/").first
            opts[:controller] = "#{namespace}/#{opts[:controller]}"
          end
        end
        route_options = opts
        route_options[:only_path] = true unless route_options.key?(:only_path) || route_options.key?(:host)
        Rails.application.routes.url_for(route_options)
      when String
        options
      else
        super
      end
    end
    helper_method :url_for

    private

    # By default Rails will render un-implemented actions when the view exists. Because Active
    # Admin allows you to not render any of the actions by using the #actions method, we need
    # to check if they are implemented.
    def only_render_implemented_actions
      raise AbstractController::ActionNotFound unless action_methods.include?(params[:action])
    end

    # Calls the authentication method as defined in ActiveAdmin.authentication_method
    def authenticate_active_admin_user
      send(active_admin_namespace.authentication_method) if active_admin_namespace.authentication_method
    end

    def current_active_admin_user
      send(active_admin_namespace.current_user_method) if active_admin_namespace.current_user_method
    end
    helper_method :current_active_admin_user

    def current_active_admin_user?
      !!current_active_admin_user
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

    def active_admin_root
      controller, action = active_admin_namespace.root_to.split "#"
      { controller: controller, action: action }
    end

    def page_presenter
      active_admin_config.get_page_presenter(params[:action].to_sym) || default_page_presenter
    end
    helper_method :page_presenter

    def default_page_presenter
      PagePresenter.new
    end

    def page_title
      if page_presenter[:title]
        helpers.render_or_call_method_or_proc_on(self, page_presenter[:title])
      else
        default_page_title
      end
    end
    helper_method :page_title

    def default_page_title
      active_admin_config.name
    end

    DEFAULT_DOWNLOAD_FORMATS = [:csv, :xml, :json]

    def build_download_formats(download_links)
      download_links = instance_exec(&download_links) if download_links.is_a?(Proc)
      if download_links.is_a?(Array) && !download_links.empty?
        download_links
      elsif download_links == false
        []
      else
        DEFAULT_DOWNLOAD_FORMATS
      end
    end
    helper_method :build_download_formats

    ActiveSupport.run_load_hooks(:active_admin_controller, self)
  end
end
