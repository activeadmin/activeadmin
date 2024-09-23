# frozen_string_literal: true
ActiveAdmin.before_load do |app|
  require_relative "batch_actions/resource_extension"
  require_relative "batch_actions/controller"

  # Add our Extensions
  ActiveAdmin::Resource.send :include, ActiveAdmin::BatchActions::ResourceExtension
  ActiveAdmin::ResourceController.send :include, ActiveAdmin::BatchActions::Controller

  require_relative "batch_actions/views/batch_action_form"
  require_relative "batch_actions/views/selection_cells"
end
