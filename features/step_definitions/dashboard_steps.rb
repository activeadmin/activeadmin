Then /^I should see the default welcome message$/ do
  step %{I should see "Welcome to Active Admin" within "#dashboard_default_message"}
end

Then /^I should not see the default welcome message$/ do
  step %{I should not see "Welcome to Active Admin"}
end

Then /^I should see a dashboard widget "([^"]*)"$/ do |name|
  page.should have_css('.dashboard .panel h3', :text => name)
end

Then /^I should not see a dashboard widget "([^"]*)"$/ do |name|
  page.should_not have_css('.dashboard .panel h3', :text => name)
end
