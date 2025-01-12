# frozen_string_literal: true
Then(/^I (should|should not) see the batch action :([^\s]*) "([^"]*)"$/) do |maybe, sym, title|
  selector = "[data-batch-action-item]"
  selector += "[href='#'][data-action='#{sym}']" if maybe == "should"

  verb = maybe == "should" ? :to : :to_not
  expect(page).send verb, have_css(selector, text: title)
end

Then(/^the (\d+)(?:st|nd|rd|th) batch action should be "([^"]*)"$/) do |index, title|
  batch_action = page.all("[data-batch-action-item]")[index.to_i - 1]
  expect(batch_action.text).to match title
end

When(/^I check the (\d+)(?:st|nd|rd|th) record$/) do |index|
  page.all(".batch-actions-resource-selection")[index.to_i].set true
end

Then(/^I should see that the batch action button is disabled$/) do
  expect(page).to have_css ".batch-actions-dropdown button[disabled]"
end

Then(/^I (should|should not) see the batch action (button|selector)$/) do |maybe, type|
  selector = ".batch-actions-dropdown"
  selector += " button" if maybe == "should" && type == "button"

  verb = maybe == "should" ? :to : :to_not
  expect(page).send verb, have_css(selector)
end

Then(/^I should see the batch action popover$/) do
  expect(page).to have_css ".batch-actions-dropdown"
end

Given(/^I submit the batch action form with "([^"]*)"$/) do |action|
  page.find_by_id('batch_action', visible: false).set action
  form = page.find_by_id 'collection_selection'
  params = page.all("#collection_selection input", visible: false).each_with_object({}) do |input, obj|
    key = input["name"]
    value = input["value"]
    if key == "collection_selection[]"
      (obj[key] ||= []).push value if input.checked?
    else
      obj[key] = value
    end
  end
  page.driver.submit form["method"], form["action"], params
end

When(/^I click "(.*?)" and accept confirmation$/) do |link|
  accept_confirm do
    click_on(link)
  end
end

Then(/^I should not see checkboxes in the table$/) do
  expect(page).to have_no_css ".paginated-collection table input[type=checkbox]"
end
