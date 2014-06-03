Then /^I (should|should not) be asked to confirm "([^"]*)" for "([^"]*)"$/ do |maybe, confirmation, title|
  selector = "#batch_actions_popover a.batch_action:contains('#{title}')"
  selector << "[data-confirm='#{confirmation}']" if maybe == 'should'

  verb = maybe == 'should' ? :to : :to_not
  expect(page).send verb, have_css(selector)
end

Then /^I (should|should not) see the batch action :([^\s]*) "([^"]*)"$/ do |maybe, sym, title|
  selector = ".batch_actions_selector a.batch_action:contains('#{title}')"
  selector << "[href='#'][data-action='#{sym}']" if maybe == 'should'

  verb = maybe == 'should' ? :to : :to_not
  expect(page).send verb, have_css(selector)
end

Then /^the (\d+)(?:st|nd|rd|th) batch action should be "([^"]*)"$/ do |index, title|
  batch_action = page.all('.batch_actions_selector a.batch_action')[index.to_i - 1]
  expect(batch_action.text).to match title
end

When /^I check the (\d+)(?:st|nd|rd|th) record$/ do |index|
  page.all("table.index_table input[type=checkbox]")[index.to_i].set true
end

When /^I toggle the collection selection$/ do
  page.find("#collection_selection_toggle_all").click
end

Then /^I should see that the batch action button is disabled$/ do
  dropdown = page.find(".batch_actions_selector .dropdown_menu_button")
  expect(dropdown[:class]).to eq('disabled dropdown_menu_button')
end

Then /^I (should|should not) see the batch action (button|selector)$/ do |maybe, type|
  selector = "div.table_tools .batch_actions_selector"
  selector << ' .dropdown_menu_button' if maybe == 'should' && type == 'button'

  verb = maybe == 'should' ? :to : :to_not
  expect(page).send verb, have_css(selector)
end

Then /^I should see the batch action popover exists$/ do
  expect(page).to have_css '.batch_actions_selector'
end

Given /^I submit the batch action form with "([^"]*)"$/ do |action|
  page.find("#batch_action").set action
  form   = page.find "#collection_selection"
  params = page.all("#main_content input").each_with_object({}) do |input, obj|
    key, value = input['name'], input['value']
    if key == 'collection_selection[]'
      (obj[key] ||= []).push value if input.checked?
    else
      obj[key] = value
    end
  end
  page.driver.submit form['method'], form['action'], params
end

Then /^I should not see checkboxes in the table$/ do
  expect(page).to_not have_css '.paginated_collection table input[type=checkbox]'
end
