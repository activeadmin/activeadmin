# frozen_string_literal: true
Around "@filters" do |scenario, block|
  previous_current_filters = ActiveAdmin.application.current_filters

  begin
    block.call
  ensure
    ActiveAdmin.application.current_filters = previous_current_filters
  end
end

Then /^I should see a select filter for "([^"]*)"$/ do |label|
  expect(page).to have_css ".filter_select label", text: label
end

Then /^I should see a string filter for "([^"]*)"$/ do |label|
  expect(page).to have_css ".filter_string label", text: label
end

Then /^I should see a date range filter for "([^"]*)"$/ do |label|
  expect(page).to have_css ".filter_date_range label", text: label
end

Then /^I should see the following filters:$/ do |table|
  table.rows_hash.each do |label, type|
    step %{I should see a #{type} filter for "#{label}"}
  end
end

Then /^I should see current filter "([^"]*)" equal to "([^"]*)" with label "([^"]*)"$/ do |name, value, label|
  expect(page).to have_css "li.current_filter_#{name} span", text: label
  expect(page).to have_css "li.current_filter_#{name} b", text: value
end

Then /^I should see current filter "([^"]*)" equal to "([^"]*)"$/ do |name, value|
  expect(page).to have_css "li.current_filter_#{name} b", text: value
end

Then /^I should see link "([^"]*)" in current filters/ do |label|
  expect(page).to have_css "li.current_filter b a", text: label
end
