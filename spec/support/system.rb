# frozen_string_literal: true
require "capybara/rspec"
require "capybara/cuprite"

Capybara.server = :webrick

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :rack_test
  end

  config.before(type: :system, js: true) do
    driven_by :cuprite, options: { process_timeout: 30, timeout: 30, protocol_timeout: 30 }
  end

  config.after(type: :system) do |example|
    exception = example.exception
    exceptions = exception.respond_to?(:all_exceptions) ? exception.all_exceptions : [exception]

    # Read the output from the exception, without trying to start Chrome again.
    exceptions.grep(Ferrum::ProcessTimeoutError).each do |error|
      warn "Chrome startup output for #{example.full_description}:\n#{error.output.presence || '(no output captured)'}"
    end
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
  end
end
