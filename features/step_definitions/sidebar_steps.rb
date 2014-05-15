Then /^I should see a sidebar titled "([^"]*)"$/ do |title|
  expect(page).to have_css '.sidebar_section h3', text: title
end

Then /^I should not see a sidebar titled "([^"]*)"$/ do |title|
  title = title.gsub(' ', '').underscore
  sidebars = page.all :css, "##{title}_sidebar_section"
  expect(sidebars.count).to eq 0
end

Then(/^I should see a sidebar titled "(.*?)" above sidebar titled "(.*?)"$/) do |top_title, bottom_title|
  expect(page).to have_css %Q(.sidebar_section:contains('#{top_title}') + .sidebar_section:contains('#{bottom_title}'))
end
