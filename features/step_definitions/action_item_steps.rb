Then /^I should see an action item link to "([^"]*)"$/ do |link|
  expect(page).to have_css('.action_item a', text: link)
end

Then /^I should not see an action item link to "([^"]*)"$/ do |link|
  expect(page).to_not have_css('.action_item a', text: link)
end
