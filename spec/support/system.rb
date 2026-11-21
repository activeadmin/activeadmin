# frozen_string_literal: true
require "capybara/rspec"
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, process_timeout: 30, timeout: 30)
end

Capybara.server = :webrick

module SystemSpecHelpers
  def login_as_admin(email: "admin@example.com")
    user = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: email)
    login_as user, scope: :admin_user
    user
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :system
  config.include SystemSpecHelpers, type: :system

  config.before(type: :system) do
    driven_by :rack_test
  end

  config.before(type: :system, js: true) do
    driven_by :cuprite
  end

  # rails_helper disables authentication for unit and request specs. System
  # specs exercise the app as a real user would, so restore the test app's
  # Devise settings for them. Each parallel_tests worker is its own process,
  # so changing this global is safe.
  config.around(type: :system) do |example|
    ActiveAdmin.application.authentication_method = :authenticate_admin_user!
    ActiveAdmin.application.current_user_method = :current_admin_user
    example.run
  ensure
    ActiveAdmin.application.authentication_method = false
    ActiveAdmin.application.current_user_method = false
    Warden.test_reset!
  end
end
