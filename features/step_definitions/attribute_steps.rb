Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  elems = all ".attributes_table th:contains('#{title}') ~ td:contains('#{value}')"
  expect(elems.first).to_not eq(nil), 'attribute missing'
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  text = all(".attributes_table th:contains('#{title}') ~ td").first.text
  expect(text).to match /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^the attribute "([^"]*)" should be empty$/ do |title|
  elems = all ".attributes_table th:contains('#{title}') ~ td > span.empty"
  expect(elems.first).to_not eq(nil), 'attribute not empty'
end

Then /^I should not see the attribute "([^"]*)"$/ do |title|
  expect(page).to_not have_css '.attributes_table th', text: title
end
