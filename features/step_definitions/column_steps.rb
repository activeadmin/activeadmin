Then /^I should see a columns container$/ do
  expect(page).to have_css '.columns'
end

Then /^I should see (a|\d+) columns?$/ do |count|
  count = count == 'a' ? 1 : count.to_i
  expect(page).to have_css '.column', count: count
end
