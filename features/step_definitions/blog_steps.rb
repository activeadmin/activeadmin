Then /^I should see a blog header "([^"]*)"$/ do |header_text|
  expect(page).to have_css 'h3', text: header_text
end
