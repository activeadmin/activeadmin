# frozen_string_literal: true
require "spec_helper"

ENV["RAILS_ENV"] = "test"

require_relative "../tasks/test_application"

require "#{ActiveAdmin::TestApplication.new.full_app_dir}/config/environment.rb"

require "rspec/rails"

require "support/arbre_helpers"
require "support/decorator_helpers"
require "support/translation_helpers"

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false
ActiveAdmin.application.load!

# These adapters register settings when loaded, so load them before the reset
# helper snapshots the application's settings.
require "active_admin/cancan_adapter"
require "active_admin/pundit_adapter"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.render_views = false

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.include ArbreHelpers
  config.include DecoratorHelpers
  config.include TranslationHelpers
end

require "support/active_admin_reset"
require "support/authentication"
require "support/system"
require "support/capybara_helpers"
require "support/resource_registration"
require "support/application_settings"
require "support/authorization_adapters"
require "support/temporary_views"

# Force deprecations to raise an exception.
ActiveAdmin::DeprecationHelper.behavior = :raise
