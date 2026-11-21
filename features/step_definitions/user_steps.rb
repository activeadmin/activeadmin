# frozen_string_literal: true
def ensure_user_created(email)
  AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: email)
end

Given(/^(?:I am logged|log) out$/) do
  click_on "Sign out" if page.all(:css, "a", text: "Sign out").any?
end

Given(/^I am logged in$/) do
  logout(:admin_user)
  login_as ensure_user_created("admin@example.com"), scope: :admin_user
end

Given(/^an admin user "([^"]*)" exists$/) do |email|
  ensure_user_created(email)
end

Given(/^"([^"]*)" requests a password reset with token "([^"]*)"( but it expires)?$/) do |email, token, expired|
  visit new_admin_user_password_path
  fill_in "Email", with: email
  allow(Devise).to receive(:friendly_token).and_return(token)
  click_on "Reset My Password"

  AdminUser.where(email: email).first.update_attribute :reset_password_sent_at, 1.month.ago if expired
end

When(/^I fill in the password field with "([^"]*)"$/) do |password|
  fill_in "admin_user_password", with: password
end
