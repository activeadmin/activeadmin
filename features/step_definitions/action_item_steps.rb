Then /^I should see an action item button "([^"]*)"$/ do |content|
  Then %{I should see "#{content}" within ".action_items a"}
end
