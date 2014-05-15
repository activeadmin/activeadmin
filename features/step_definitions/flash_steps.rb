Then /^I should see a flash with "([^"]*)"$/ do |text|
  expect(page).to have_content text
end

Then /^I should see a successful create flash$/ do
  expect(page).to have_css 'div.flash_notice', text: /was successfully created/
end

Then /^I should not see a successful create flash$/ do
  expect(page).to_not have_css 'div.flash_notice', text: /was successfully created/
end
