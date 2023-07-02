# frozen_string_literal: true
require "spec_helper"

ENV["RAILS_ENV"] = "test"

require_relative "../tasks/test_application"

require "#{ActiveAdmin::TestApplication.new.full_app_dir}/config/environment.rb"

require "rspec/rails"

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.render_views = false

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  require "support/active_admin_integration_spec_helper"
  config.include ActiveAdminIntegrationSpecHelper

  config.before(:each, type: :system) do
    # Reload Active Admin
    ActiveAdmin.unload!
    ActiveAdmin.load!
  end
end

# Force deprecations to raise an exception.
ActiveSupport::Deprecation.behavior = :raise

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, process_timeout: 30, timeout: 30)
end

Capybara.javascript_driver = :cuprite

Capybara.server = :webrick

Capybara.asset_host = "http://localhost:3000"

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css
