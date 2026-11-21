# frozen_string_literal: true
Then(/^I should not see pagination$/) do
  expect(page).to have_no_css "[data-test-pagination]"
end
