Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  Then "I should see \"#{title}\" within \"table.resource_attributes th\""
  And "I should see \"#{value}\" within \"table.resource_attributes td\""
end
