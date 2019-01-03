require 'active_admin/dynamic_settings_node'

module ActiveAdmin
  class NamespaceSettings < DynamicSettingsNode
    # The default number of resources to display on index pages
    register :default_per_page, 30

    # The max number of resources to display on index pages and batch exports
    register :max_per_page, 10_000

    # The title which gets displayed in the main layout
    register :site_title, "", :string_symbol_or_proc

    # Set the site title link href (defaults to AA dashboard)
    register :site_title_link, ""

    # Set the site title image displayed in the main layout (has precendence over :site_title)
    register :site_title_image, "", :string_symbol_or_proc

    # Add to the site head
    register :head, "", :string_symbol_or_proc

    # Set the site footer text (defaults to Powered by ActiveAdmin text with version)
    register :footer, "", :string_symbol_or_proc

    # Set a favicon
    register :favicon, false

    # Additional meta tags to place in head of logged in pages
    register :meta_tags, {}

    # Additional meta tags to place in head of logged out pages
    register :meta_tags_for_logged_out_pages, { robots: "noindex, nofollow" }

    # The view factory to use to generate all the view classes. Take
    # a look at ActiveAdmin::ViewFactory
    register :view_factory, ActiveAdmin::ViewFactory.new

    # The method to call in controllers to get the current user
    register :current_user_method, false

    # The method to call in the controllers to ensure that there
    # is a currently authenticated admin user
    register :authentication_method, false

    # The path to log user's out with. If set to a symbol, we assume
    # that it's a method to call which returns the path
    register :logout_link_path, :destroy_admin_user_session_path

    # The method to use when generating the link for user logout
    register :logout_link_method, :get

    # Whether the batch actions are enabled or not
    register :batch_actions, false

    # Whether filters are enabled
    register :filters, true

    # The namespace root
    register :root_to, 'dashboard#index'

    # Options that are passed to root_to
    register :root_to_options, {}

    # Options passed to the routes, i.e. { path: '/custom' }
    register :route_options, {}

    # Display breadcrumbs
    register :breadcrumb, true

    # Display create another checkbox on a new page
    # @return [Boolean] (true)
    register :create_another, false

    # Default CSV options
    register :csv_options, { col_sep: ',', byte_order_mark: "\xEF\xBB\xBF" }

    # Default Download Links options
    register :download_links, true

    # The authorization adapter to use
    register :authorization_adapter, ActiveAdmin::AuthorizationAdapter

    # A proc to be used when a user is not authorized to view the current resource
    register :on_unauthorized_access, :rescue_active_admin_access_denied

    # A regex to detect unsupported browser, set to false to disable
    register :unsupported_browser_matcher, /MSIE [1-8]\.0/

    # Whether to display 'Current Filters' on search screen
    register :current_filters, true

    # class to handle ordering
    register :order_clause, ActiveAdmin::OrderClause

    # default show_count for scopes
    register :scopes_show_count, true

    # Request parameters that are permitted by default
    register :permitted_params, [
      :utf8, :_method, :authenticity_token, :commit, :id
    ]

    # Set flash message keys that shouldn't show in ActiveAdmin
    register :flash_keys_to_except, ['timedout']

    # Include association filters by default
    register :include_default_association_filters, true
  end
end
