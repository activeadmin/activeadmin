# frozen_string_literal: true
require "active_support/core_ext"
require "set"

require "ransack"
require "kaminari"
require "formtastic"
require "formtastic_i18n"
require "inherited_resources"
require "jquery-rails"
require "arbre"

require "active_admin/helpers/i18n"

module ActiveAdmin

  autoload :VERSION, "active_admin/version"
  autoload :Application, "active_admin/application"
  autoload :AssetRegistration, "active_admin/asset_registration"
  autoload :Authorization, "active_admin/authorization_adapter"
  autoload :AuthorizationAdapter, "active_admin/authorization_adapter"
  autoload :Callbacks, "active_admin/callbacks"
  autoload :Component, "active_admin/component"
  autoload :BaseController, "active_admin/base_controller"
  autoload :CanCanAdapter, "active_admin/cancan_adapter"
  autoload :ControllerAction, "active_admin/controller_action"
  autoload :CSVBuilder, "active_admin/csv_builder"
  autoload :Dependency, "active_admin/dependency"
  autoload :Devise, "active_admin/devise"
  autoload :DSL, "active_admin/dsl"
  autoload :FormBuilder, "active_admin/form_builder"
  autoload :Inputs, "active_admin/inputs"
  autoload :Localizers, "active_admin/localizers"
  autoload :Menu, "active_admin/menu"
  autoload :MenuCollection, "active_admin/menu_collection"
  autoload :MenuItem, "active_admin/menu_item"
  autoload :Namespace, "active_admin/namespace"
  autoload :OrderClause, "active_admin/order_clause"
  autoload :Page, "active_admin/page"
  autoload :PagePresenter, "active_admin/page_presenter"
  autoload :PageController, "active_admin/page_controller"
  autoload :PageDSL, "active_admin/page_dsl"
  autoload :PunditAdapter, "active_admin/pundit_adapter"
  autoload :Resource, "active_admin/resource"
  autoload :ResourceController, "active_admin/resource_controller"
  autoload :ResourceDSL, "active_admin/resource_dsl"
  autoload :Scope, "active_admin/scope"
  autoload :ScopeChain, "active_admin/helpers/scope_chain"
  autoload :SidebarSection, "active_admin/sidebar_section"
  autoload :TableBuilder, "active_admin/table_builder"
  autoload :ViewFactory, "active_admin/view_factory"
  autoload :ViewHelpers, "active_admin/view_helpers"
  autoload :Views, "active_admin/views"

  class << self

    attr_accessor :application

    def application
      @application ||= ::ActiveAdmin::Application.new
    end

    def deprecator
      @deprecator ||= ActiveSupport::Deprecation.new("4.0", "active-admin")
    end

    # Gets called within the initializer
    def setup
      application.setup!
      yield(application)
      application.prepare!
    end

    delegate :register, to: :application
    delegate :register_page, to: :application
    delegate :unload!, to: :application
    delegate :load!, to: :application
    delegate :routes, to: :application

    # A callback is triggered each time (before) Active Admin loads the configuration files.
    # In development mode, this will happen whenever the user changes files. In production
    # it only happens on boot.
    #
    # The block takes the current instance of [ActiveAdmin::Application]
    #
    # Example:
    #
    #     ActiveAdmin.before_load do |app|
    #       # Do some stuff before AA loads
    #     end
    #
    # @param [Block] block A block to call each time (before) AA loads resources
    def before_load(&block)
      ActiveSupport::Notifications.subscribe ActiveAdmin::Application::BeforeLoadEvent, &wrap_block_for_active_support_notifications(block)
    end

    # A callback is triggered each time (after) Active Admin loads the configuration files. This
    # is an opportunity to hook into Resources after they've been loaded.
    #
    # The block takes the current instance of [ActiveAdmin::Application]
    #
    # Example:
    #
    #     ActiveAdmin.after_load do |app|
    #       app.namespaces.each do |name, namespace|
    #         puts "Namespace: #{name} loaded!"
    #       end
    #     end
    #
    # @param [Block] block A block to call each time (after) AA loads resources
    def after_load(&block)
      ActiveSupport::Notifications.subscribe ActiveAdmin::Application::AfterLoadEvent, &wrap_block_for_active_support_notifications(block)
    end

    private

    def wrap_block_for_active_support_notifications block
      proc { |_name, _start, _finish, _id, payload| block.call payload[:active_admin_application] }
    end

  end

end

# Require things that don't support autoload
require "active_admin/engine"
require "active_admin/error"

# Require internal plugins
require "active_admin/batch_actions"
require "active_admin/filters"

# Require ORM-specific plugins
require "active_admin/orm/active_record" if defined? ActiveRecord
require "active_admin/orm/mongoid" if defined? Mongoid
