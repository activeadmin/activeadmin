# frozen_string_literal: true
Then /^I should see an action item button "([^"]*)"$/ do |content|
  expect(page).to have_css ".page-title-bar-actions a", text: content
end

Then /^I should not see an action item button "([^"]*)"$/ do |content|
  expect(page).to_not have_css ".page-title-bar-actions", text: content
end
