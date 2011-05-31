Then /^I should see the default welcome message$/ do
  Then %{I should see "Welcome to Active Admin" within "#dashboard_default_message"}
end

Then /^I should not see the default welcome message$/ do
  Then %{I should not see "Welcome to Active Admin"}
end

Then /^I should see a dashboard widget "([^"]*)"$/ do |name|
  Then %{I should see "#{name}" within ".dashboard .panel h3"}
end
