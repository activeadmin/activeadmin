def ensure_user_created(email)
  user = AdminUser.where(:email => email).first_or_create(:password => 'password', :password_confirmation => 'password')

  unless user.persisted?
    raise "Could not create user #{email}: #{user.errors.full_messages}"
  end
  user
end

Given /^(?:I am logged|log) out$/ do
  click_link 'Logout' if page.all(:css, "a", :text => 'Logout').any?
end

Given /^I am logged in$/ do
  step 'log out'
  login_as ensure_user_created 'admin@example.com'
end

# only for @requires-reloading scenario
Given /^I am logged in with capybara$/ do
  ensure_user_created 'admin@example.com'
  step 'log out'

  visit new_admin_user_session_path
  fill_in 'Email',    :with => 'admin@example.com'
  fill_in 'Password', :with => 'password'
  click_button 'Login'
end

Given /^an admin user "([^"]*)" exists$/ do |email|
  ensure_user_created(email)
end

Given /^an admin user "([^"]*)" exists with( expired)? reset password token "(.*?)"$/ do |email, expired, token|
  user = ensure_user_created(email)
  user.reset_password_token   = token
  user.reset_password_sent_at = 1.minute.ago unless expired
  user.save
end
