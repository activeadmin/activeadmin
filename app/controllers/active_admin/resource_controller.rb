# frozen_string_literal: true
require "active_admin/collection_decorator"

module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class ResourceController < BaseController
    respond_to :html, :xml, :json
    respond_to :csv, only: :index

    before_action :restrict_download_format_access!, only: [:index, :show]

    include ResourceController::ActionBuilder
    include ResourceController::Decorators
    include ResourceController::DataAccess
    include ResourceController::PolymorphicRoutes
    include ResourceController::Scoping
    include ResourceController::Streaming
    extend ResourceClassMethods

    def self.active_admin_config=(config)
      if @active_admin_config = config
        defaults resource_class: config.resource_class,
                 route_prefix: config.route_prefix,
                 instance_name: config.resource_name.singular
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

    def page_presenter
      case params[:action].to_sym
      when :index
        active_admin_config.get_page_presenter(params[:action], params[:as])
      when :new, :edit, :create, :update
        active_admin_config.get_page_presenter(:form)
      end || super
    end

    def default_page_presenter
      case params[:action].to_sym
      when :index
        PagePresenter.new(as: :table)
      when :new, :edit
        PagePresenter.new
      end || super
    end

    def page_title
      if page_presenter[:title]
        case params[:action].to_sym
        when :index
          case page_presenter[:title]
          when Symbol, Proc
            instance_exec(&page_presenter[:title])
          else
            page_presenter[:title]
          end
        else
          helpers.render_or_call_method_or_proc_on(resource, page_presenter[:title])
        end
      else
        default_page_title
      end
    end

    def default_page_title
      case params[:action].to_sym
      when :index
        active_admin_config.plural_resource_label
      when :show
        helpers.display_name(resource)
      when :new, :edit, :create, :update
        normalized_action = params[:action]
        normalized_action = 'new' if normalized_action == 'create'
        normalized_action = 'edit' if normalized_action == 'update'

        ActiveAdmin::Localizers.resource(active_admin_config).t("#{normalized_action}_model")
      else
        I18n.t("active_admin.#{params[:action]}", default: params[:action].to_s.titleize)
      end
    end

    def restrict_download_format_access!
      unless request.format.html?
        presenter = active_admin_config.get_page_presenter(:index)
        download_formats = (presenter || {}).fetch(:download_links, active_admin_config.namespace.download_links)
        unless build_download_formats(download_formats).include?(request.format.symbol)
          raise ActiveAdmin::AccessDenied.new(current_active_admin_user, :index)
        end
      end
    end
  end
end
