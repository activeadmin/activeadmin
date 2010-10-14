Given /^I am logged out$/ do
  visit "/admin/sign_out"
end

Given /^an admin user "([^"]*)" exists$/ do |admin_email|
  unless AdminUser.find_by_email(admin_email)
    AdminUser.create! :email => admin_email,
                      :password => "password",
                      :password_confirmation => "password"
  end
end
