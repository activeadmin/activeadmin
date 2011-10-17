Then /^I should see an action item button "([^"]*)"$/ do |content|
  page.should have_css(".action_items a", :text => content)
end

Then /^I should not see an action item button "([^"]*)"$/ do |content|
  page.should_not have_css(".action_items", :text => content)
end
