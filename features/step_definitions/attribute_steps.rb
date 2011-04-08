Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  Then "I should see \"#{title}\" within \".attributes_table th\""
  And "I should see \"#{value}\" within \".attributes_table td\""
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  Then "I should see \"#{title}\" within \".attributes_table th\""
  with_scope ".attributes_table td" do
    page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
  end
end

Then /^I should not see the attribute "([^"]*)"$/ do |title|
  Then "I should not see \"#{title}\" within \".attributes_table th\""
end
