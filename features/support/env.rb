# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"

require_relative "../../spec/support/simplecov_helper"

ActiveAdmin::TestSupport::SimpleCovHelper.start("features")

Dir["#{File.expand_path('../step_definitions', __dir__)}/*.rb"].each do |f|
  require f
end

require_relative "../../tasks/test_application"

require "#{ActiveAdmin::TestApplication.new.full_app_dir}/config/environment.rb"

require_relative "rails"
require_relative "../../spec/support/active_support_deprecation"

After "@debug" do |scenario|
  # simplecov:disable
  save_and_open_page if scenario.failed?
  # simplecov:enable
end

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

# Database resetting strategy
DatabaseCleaner.strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

# Warden helpers to speed up login
# See https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
include Warden::Test::Helpers
Devise.configure_warden!

After do
  Warden.test_reset!
end

Before do
  # Reload Active Admin
  ActiveAdmin.unload!
  ActiveAdmin.load!
end

# Force deprecations to raise an exception.
ActiveAdmin::DeprecationHelper.behavior = :raise
