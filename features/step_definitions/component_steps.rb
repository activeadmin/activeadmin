# frozen_string_literal: true
When(/^I click the element "([^"]*)"$/) do |selector|
  find(selector).click
end

When(/^I press the Escape key$/) do
  page.driver.browser.keyboard.type(:Escape)
end

When(/^I click the modal backdrop$/) do
  page.execute_script("document.querySelector('[aria-modal=\"true\"]').click()")
end
