Then /^I should see the default footer$/ do
  expect(page).to have_css '#footer', text: "Powered by Active Admin #{ActiveAdmin::VERSION}"
end

Then /^I should see the footer "([^"]*)"$/ do |footer|
  expect(page).to have_css '#footer', text: footer
end

Then /^I should not see the footer "([^"]*)"$/ do |footer|
  expect(page).to_not have_css '#footer', text: footer
end
