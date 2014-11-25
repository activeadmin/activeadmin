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

Then(/^I should( not)? see parameter "([^"]*)" with value "([^"]*)"$/) do |negative, key, value|
  uri_with_params= page.current_url.split('?')
  params_string= (uri_with_params.length == 2) ? uri_with_params[1]: nil
  expect(params_string).to_not be_nil
  params= Hash.new
  params_string.split('&').each do |pair|
  params[pair.split('=')[0]]= pair.split('=')[1]
  end
  if params != nil
   negative ? (expect(params[key]).to be_falsey)
   : (expect(params[key]).to be_truthy) && (expect(params[key]).to eq(value))
  end
end
