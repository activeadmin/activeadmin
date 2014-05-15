Then /^I should see a menu item for "([^"]*)"$/ do |name|
  expect(page).to have_css '#tabs li a', text: name
end

Then /^I should not see a menu item for "([^"]*)"$/ do |name|
  expect(page).to_not have_css '#tabs li a', text: name
end

Then /^I should see a nested menu item for "([^"]*)"$/ do |name|
  expect(page).to have_css '#tabs > li > ul > li > a', text: name
end
