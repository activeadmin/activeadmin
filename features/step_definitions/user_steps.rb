# frozen_string_literal: true
def ensure_user_created(email)
  AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: email)
end

Given(/^I am logged in$/) do
  logout(:admin_user)
  login_as ensure_user_created("admin@example.com"), scope: :admin_user
end
