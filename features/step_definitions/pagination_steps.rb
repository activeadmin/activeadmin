# frozen_string_literal: true
Then /^I should not see pagination$/ do
  expect(page).to_not have_css ".pagination"
end

Then /^I should see pagination page (\d+) link$/ do |num|
  expect(page).to have_css ".pagination a", text: num, count: 1
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
