# frozen_string_literal: true
Then(/^I should see (\d+) ([\w]*) in the table$/) do |count, resource_type|
  expect(page).to have_css(".data-table tr > td:first-child", count: count.to_i)
end
