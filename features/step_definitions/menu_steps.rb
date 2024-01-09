# frozen_string_literal: true
Then /^I should see a menu item for "([^"]*)"$/ do |name|
  expect(page).to have_css "#main-menu li a", text: name
end

Then /^I should not see a menu item for "([^"]*)"$/ do |name|
  expect(page).to_not have_css "#main-menu li a", text: name
end

Then /^the "([^"]*)" menu item should be hidden$/ do |name|
  expect(page).to have_css "#main-menu .hidden a", text: name
end

Then /^I should see a menu parent for "([^"]*)"$/ do |name|
  expect(page).to have_css "#main-menu li a", text: name
end

Then /^I should see a nested menu item for "([^"]*)"$/ do |name|
  expect(page).to have_css "#main-menu li li a", text: name
end

Then /^the "([^"]*)" menu item should be selected$/ do |name|
  expect(page).to have_css "#main-menu li a.selected", text: name
end
