Then /^I should see a link to "([^"]*)" in the breadcrumb$/ do |text|
  expect(page).to have_css '.breadcrumb > a', text: text
end
