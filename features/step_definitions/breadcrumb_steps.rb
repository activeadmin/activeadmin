# frozen_string_literal: true
Then(/^I should see a link to "([^"]*)" in the breadcrumb$/) do |text|
  expect(page).to have_css "nav[aria-label=breadcrumb] a", text: text
end
