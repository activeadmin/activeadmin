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
