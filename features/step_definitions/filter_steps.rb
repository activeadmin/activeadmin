Then /^I should see a select filter for "([^"]*)"$/ do |label|
  expect(page).to have_css '.filter_select label', text: label
end

Then /^I should see a string filter for "([^"]*)"$/ do |label|
  expect(page).to have_css '.filter_string label', text: label
end

Then /^I should see a date range filter for "([^"]*)"$/ do |label|
  expect(page).to have_css '.filter_date_range label', text: label
end

Then /^I should see the following filters:$/ do |table|
  table.rows_hash.each do |label, type|
    step %{I should see a #{type} filter for "#{label}"}
  end
end

Given(/^I add parameter "([^"]*)" with value "([^"]*)" to the URL$/) do |key, value|
  url = page.current_url
  separator = url.include?('?') ? '&' : '?'
  visit url + separator + key.to_s + '=' + value.to_s
end

Then(/^I should( not)? have parameter "([^"]*)"( with value "([^"]*)")?$/) do |negative, key, compare_val, value|
  query = URI(page.current_url).query
  if query.nil?
    expect(negative).to eq true
  else
    params = Rack::Utils.parse_query query
    if compare_val
      expect(params[key]).to_not eq value if negative
      expect(params[key]).to eq value unless negative
    else
      expect(params[key]).to eq nil if negative
      expect(params[key]).to be_present unless negative
    end
  end
end
