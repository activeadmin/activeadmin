# frozen_string_literal: true

Then(/^I should not see an action item link to "([^"]*)"$/) do |link|
  expect(page).to have_no_css("[data-test-action-items] > a", text: link)
end
