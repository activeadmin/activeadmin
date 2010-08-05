ActiveAdmin.setup do |config|

  # == Site Title
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  # If you don't set it here, it defaults to a friendly
  # name of your Rails.application class name.
  #
  # config.site_title = "My Great Site"

  # == Default Namespace
  # Set the default namespace each administration resource
  # will be added to. 
  #
  # eg: 
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  config.default_namespace = :admin

end
