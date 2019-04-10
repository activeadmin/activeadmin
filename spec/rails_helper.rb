require 'spec_helper'

ENV['RAILS_ENV'] = 'test'

require_relative "../gemfiles/rails_version"

require_relative "../tmp/rails/rails-#{TestEnvironment.rails_version}/config/environment"

require 'rspec/rails'

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.render_views = false

  config.include Devise::Test::ControllerHelpers, type: :controller

  require 'support/active_admin_integration_spec_helper'
  config.include ActiveAdminIntegrationSpecHelper
end

# Force deprecations to raise an exception.
ActiveSupport::Deprecation.behavior = :raise
