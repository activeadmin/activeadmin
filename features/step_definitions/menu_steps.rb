# frozen_string_literal: true
Then(/^I should see a menu item for "([^"]*)"$/) do |name|
  expect(page).to have_css "#main-menu li a", text: name
end

Then(/^I should not see a menu item for "([^"]*)"$/) do |name|
  expect(page).to have_no_css "#main-menu li a", text: name
end

Then(/^the "([^"]*)" menu item should be selected$/) do |name|
  expect(page).to have_css "#main-menu li a.selected", text: name
end
