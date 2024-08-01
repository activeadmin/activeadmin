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

Then /^I should see a number filter for "([^"]*)"$/ do |label|
  expect(page).to have_css ".filter_numeric label", text: label
end

Then /^I should see the following filters:$/ do |table|
  table.rows_hash.each do |label, type|
    step %{I should see a #{type} filter for "#{label}"}
  end
end

Given(/^I add parameter "([^"]*)" with value "([^"]*)" to the URL$/) do |key, value|
  url = page.current_url
  separator = url.include?("?") ? "&" : "?"
  visit url + separator + key.to_s + "=" + value.to_s
end

Then(/^I should have parameter "([^"]*)" with value "([^"]*)"$/) do |key, value|
  query = URI(page.current_url).query
  params = Rack::Utils.parse_query query
  expect(params[key]).to eq value
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
