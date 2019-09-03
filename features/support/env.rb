ENV['RAILS_ENV'] = 'test'

require 'simplecov' if ENV["COVERAGE"] == "true"

Dir["#{File.expand_path('../step_definitions', __dir__)}/*.rb"].each do |f|
  require f
end

require_relative "../../tasks/test_application"

require "#{ActiveAdmin::TestApplication.new.full_app_dir}/config/environment.rb"

require_relative 'rails'

require 'rspec/mocks'
World(RSpec::Mocks::ExampleMethods)

Around '@mocks' do |scenario, block|
  RSpec::Mocks.setup

  block.call

  begin
    RSpec::Mocks.verify
  ensure
    RSpec::Mocks.teardown
  end
end

After '@debug' do |scenario|
  # :nocov:
  save_and_open_page if scenario.failed?
  # :nocov:
end

require 'capybara/dsl'

World(Capybara::DSL)

After do
  Capybara.reset_sessions!
end

Before do
  Capybara.use_default_driver
end

Before '@javascript' do
  Capybara.current_driver = Capybara.javascript_driver
end

require "capybara/apparition"
Capybara.javascript_driver = :apparition

Capybara.server = :webrick

Capybara.asset_host = 'http://localhost:3000'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# Database resetting strategy
DatabaseCleaner.strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

# Warden helpers to speed up login
# See https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
include Warden::Test::Helpers

After do
  Warden.test_reset!
end

Before do
  # We are caching classes, but need to manually clear references to
  # the controllers. If they aren't clear, the router stores references
  ActiveSupport::Dependencies.clear unless ActiveAdmin::Dependency.supports_zeitwerk?

  # Reload Active Admin
  ActiveAdmin.unload!
  ActiveAdmin.load!
end

# Force deprecations to raise an exception.
ActiveSupport::Deprecation.behavior = :raise

After '@authorization' do |scenario, block|
  # Reset back to the default auth adapter
  ActiveAdmin.application.namespace(:admin).
    authorization_adapter = ActiveAdmin::AuthorizationAdapter
end

Around '@silent_unpermitted_params_failure' do |scenario, block|
  original = ActionController::Parameters.action_on_unpermitted_parameters

  begin
    ActionController::Parameters.action_on_unpermitted_parameters = false
    block.call
  ensure
    ActionController::Parameters.action_on_unpermitted_parameters = original
  end
end

Around '@locale_manipulation' do |scenario, block|
  I18n.with_locale(:en, &block)
end
