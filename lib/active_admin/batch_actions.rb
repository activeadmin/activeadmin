ActiveAdmin.before_load do |app|
  require "active_admin/batch_actions/resource_extension"
  require "active_admin/batch_actions/controller"

  # Add our Extensions
  ActiveAdmin::Resource.send :include, ActiveAdmin::BatchActions::ResourceExtension
  ActiveAdmin::ResourceController.send :include, ActiveAdmin::BatchActions::Controller

  # Require all the views
  require "active_admin/batch_actions/views/batch_action_form"
  require "active_admin/batch_actions/views/batch_action_popover"
  require "active_admin/batch_actions/views/selection_cells"
  require "active_admin/batch_actions/views/batch_action_selector"

  # Register the views with the view factory
  app.view_factory.register batch_action_selector: ActiveAdmin::BatchActions::BatchActionSelector
end
