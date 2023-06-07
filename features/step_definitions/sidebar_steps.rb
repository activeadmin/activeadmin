# frozen_string_literal: true
Then /^I should see a sidebar titled "([^"]*)"$/ do |title|
  expect(page).to have_css ".sidebar_section h3", text: title
end

Then /^I should not see a sidebar titled "([^"]*)"$/ do |title|
  expect(page).not_to have_css ".sidebar_section h3", text: title
end

Then(/^I should see a sidebar titled "(.*?)" above sidebar titled "(.*?)"$/) do |top_title, bottom_title|
  expect(page).to have_css %Q(.sidebar_section:contains('#{top_title}') + .sidebar_section:contains('#{bottom_title}'))
end
