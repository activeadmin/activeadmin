# frozen_string_literal: true
Then(/^I should not see pagination$/) do
  expect(page).to have_no_css "[data-test-pagination]"
end

Then(/^I should see pagination page (\d+) link$/) do |num|
  expect(page).to have_css "[data-test-pagination] a", text: num, count: 1
end

Then(/^I should see the pagination "Next" link/) do
  expect(page).to have_css "[data-test-pagination] a", text: "Next"
end

Then(/^I should not see the pagination "Next" link/) do
  expect(page).to have_no_css "[data-test-pagination] a", text: "Next"
end
