# frozen_string_literal: true
When(/^I click the element "([^"]*)"$/) do |selector|
  find(selector).click
end

When(/^I click the modal backdrop$/) do
  page.execute_script("document.querySelector('[aria-modal=\"true\"]').click()")
end

When(/^I focus the element "([^"]*)"$/) do |selector|
  find(selector).execute_script("this.focus()")
end

When(/^I press the "([^"]*)" key$/) do |key|
  key_map = {
    "ArrowDown" => :down,
    "ArrowUp" => :up,
    "ArrowLeft" => :left,
    "ArrowRight" => :right,
  }
  page.driver.browser.keyboard.type(key_map.fetch(key, key.downcase.to_sym))
end

Then(/^the active element should be inside "([^"]*)"$/) do |selector|
  expect(page.evaluate_script("document.querySelector(#{selector.to_json}).contains(document.activeElement)")).to be true
end

Then(/^the active element should match "([^"]*)"$/) do |selector|
  expect(page.evaluate_script("document.activeElement.matches(#{selector.to_json})")).to be true
end
