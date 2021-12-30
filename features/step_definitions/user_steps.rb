# frozen_string_literal: true
def ensure_user_created(email)
  AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: email)
end

Given /^(?:I am logged|log) out$/ do
  click_link "Logout" if page.all(:css, "a", text: "Logout").any?
end

Given /^I am logged in$/ do
  logout(:user)
  login_as ensure_user_created "admin@example.com"
end

Given /^I am logged in with capybara$/ do
  ensure_user_created "admin@example.com"
  step "log out"

  visit new_admin_user_session_path
  fill_in "Email", with: "admin@example.com"
  fill_in "Password", with: "password"
  click_button "Login"
end

Given /^an admin user "([^"]*)" exists$/ do |email|
  ensure_user_created(email)
end

Given /^"([^"]*)" requests a password reset with token "([^"]*)"( but it expires)?$/ do |email, token, expired|
  visit new_admin_user_password_path
  fill_in "Email", with: email
  allow(Devise).to receive(:friendly_token).and_return(token)
  click_button "Reset My Password"

  AdminUser.where(email: email).first.update_attribute :reset_password_sent_at, 1.month.ago if expired
end

Given /^override locale "([^"]*)" with "([^"]*)"$/ do |path, value|
  keys_value = path.split(".") + [value]
  locale_hash = keys_value.reverse.inject { |a, n| { n => a } }
  I18n.available_locales
  I18n.backend.store_translations(I18n.locale, locale_hash)
end

When /^I fill in the password field with "([^"]*)"$/ do |password|
  fill_in "admin_user_password", with: password
end
