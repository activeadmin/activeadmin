# frozen_string_literal: true
Then(/^I should see (\d+) ([\w]*) in the table$/) do |count, resource_type|
  expect(page).to have_css(".data-table tr > td:first-child", count: count.to_i)
end

Then("I should see {string} in the table") do |string|
  expect(page).to have_css(".data-table tr > td", text: string)
end

Then("I should not see {string} in the table") do |string|
  expect(page).to have_no_css(".data-table tr > td", text: string)
end
