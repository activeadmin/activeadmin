require 'spec_helper'

ENV['RAILS_ENV'] = 'test'

require 'rails'
ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{Rails.version}", __FILE__)

# Create the test app if it doesn't exists
unless File.exists?(ENV['RAILS_ROOT'])
  system 'rake setup'
end

require 'active_record'
require 'active_admin'
require 'devise'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]

require ENV['RAILS_ROOT'] + '/config/environment'

require 'rspec/rails'

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.render_views = false
  config.filter_run focus: true
  config.filter_run_excluding skip: true
  config.run_all_when_everything_filtered = true
  config.color = true
  config.order = :random

  devise = ActiveAdmin::Dependency.devise >= '4.2' ? Devise::Test::ControllerHelpers : Devise::TestHelpers
  config.include devise, type: :controller

  require 'support/active_admin_integration_spec_helper'
  config.include ActiveAdminIntegrationSpecHelper

  require 'support/active_admin_request_helpers'
  config.include ActiveAdminRequestHelpers, type: :request

  # Setup Some Admin stuff for us to play with
  config.before(:suite) do
    ActiveAdminIntegrationSpecHelper.load_defaults!
    ActiveAdminIntegrationSpecHelper.reload_routes!
  end
end

# Force deprecations to raise an exception.
ActiveSupport::Deprecation.behavior = :raise

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = Logger::FATAL
