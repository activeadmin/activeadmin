# frozen_string_literal: true

# Signs in an admin user for request and system specs.
#
#   login_as_admin
#
# Request specs run with Active Admin authentication turned off (see
# rails_helper), so they only need this when the page uses the current
# user, e.g. a site title built from their email. System specs turn
# authentication on, so they always need it.
module AuthenticationHelpers
  def login_as_admin(email: "admin@example.com")
    user = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: email)
    login_as user, scope: :admin_user
    user
  end

  # Turns on the test app's Devise authentication and current user method
  # for the current example. Request specs run with both off; use this when
  # a request spec needs Active Admin to know who's signed in, e.g. to
  # check authorization. Pair it with login_as_admin.
  def enable_authentication
    set_application_setting(:authentication_method, :authenticate_admin_user!)
    set_application_setting(:current_user_method, :current_admin_user)
  end
end

RSpec.configure do |config|
  [:request, :system].each do |type|
    config.include Warden::Test::Helpers, type: type
    config.include AuthenticationHelpers, type: type

    # Warden only defines test_reset! once its test helpers are included,
    # so this can't run after unit specs.
    config.after(type: type) { Warden.test_reset! }
  end
end
