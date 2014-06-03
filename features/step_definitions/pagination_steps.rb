Then /^I should not see pagination$/ do
  expect(page).to_not have_css '.pagination'
end

Then /^I should see pagination with (\d+) pages$/ do |count|
  expect(page).to have_css '.pagination span.page', count: count
end
