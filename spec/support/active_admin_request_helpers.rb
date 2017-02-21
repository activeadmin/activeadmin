require "action_dispatch"
require "capybara/rails"
require "capybara/dsl"

module ActiveAdminRequestHelpers
  extend ActiveSupport::Concern

  include ActionDispatch::Integration::Runner
  include RSpec::Rails::TestUnitAssertionAdapter
  include ActionDispatch::Assertions
  include Capybara::DSL
  include RSpec::Matchers

  def app
    ::Rails.application
  end

  def last_response
    page
  end

  included do
    before do
      @router = ::Rails.application.routes
    end
  end

  def with_temp_application(application)
    original_application = ActiveAdmin.application
    ActiveAdmin.application = application
    load_defaults!
    reload_routes!

    yield

  ensure
    ActiveAdmin.application = original_application
  end
end
