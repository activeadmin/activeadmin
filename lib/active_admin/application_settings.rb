# frozen_string_literal: true
require "active_admin/settings_node"

module ActiveAdmin
  class ApplicationSettings < SettingsNode

    # The default namespace to put controllers and routes inside. Set this
    # in config/initializers/active_admin.rb using:
    #
    #   config.default_namespace = :super_admin
    #
    register :default_namespace, :admin

    register :app_path, Rails.root

    # Load paths for admin configurations. Add folders to this load path
    # to load up other resources for administration. External gems can
    # include their paths in this load path to provide active_admin UIs
    register :load_paths, [File.expand_path("app/admin", Rails.root)]

    # Set default localize format for Date/Time values
    register :localize_format, :long

    # Active Admin makes educated guesses when displaying objects, this is
    # the list of methods it tries calling in order
    # Note that Formtastic also has 'collection_label_methods' similar to this
    # used by auto generated dropdowns in filter or belongs_to field of Active Admin
    register :display_name_methods, [ :display_name,
                                      :full_name,
                                      :name,
                                      :username,
                                      :login,
                                      :title,
                                      :email,
                                      :to_s ]

    # To make debugging easier, by default don't stream in development
    register :disable_streaming_in, ["development"]

    # Remove sensitive attributes from being displayed, made editable, or exported by default
    register :filter_attributes, [:encrypted_password, :password, :password_confirmation]
  end
end
