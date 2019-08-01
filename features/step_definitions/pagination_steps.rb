Then /^I should not see pagination$/ do
  expect(page).to_not have_css '.pagination'
end

Then /^I should see pagination with (\d+) pages$/ do |count|
  expect(page).to have_css '.pagination span.page', count: count
end

Then /^I should see the pagination "Next" link/ do
  expect(page).to have_css "a", text: "Next"
end

Then /^I should not see the pagination "Next" link/ do
  expect(page).to_not have_css "a", text: "Next"
end

Then /^I should not see the pagination "Last" link/ do
  expect(page).to_not have_css "a", text: "Last"
end
