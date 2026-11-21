# frozen_string_literal: true

Then(/^I should see a link to "([^"]*)"$/) do |link|
  if Capybara.current_driver == Capybara.javascript_driver
    expect(page).to have_xpath "//a", text: link, wait: 30
  else
    expect(page).to have_xpath "//a", text: link
  end
end
