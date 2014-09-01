Then /^the "([^"]*)" tab should be selected$/ do |name|
  step %{I should see "#{name}" within "ul#tabs li.current"}
end

Then(/^I should see two tabs "(.*?)" and "(.*?)"$/) do |tab_1, tab_2|
  expect(page).to have_link(tab_1)
  expect(page).to have_link(tab_2)
end
