Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  elems = all ".attributes_table th:contains('#{title}') ~ td:contains('#{value}')"
  elems.first.should_not be_nil, 'attribute missing'
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  text = all(".attributes_table th:contains('#{title}') ~ td").first.text
  text.should match /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should not see the attribute "([^"]*)"$/ do |title|
  page.should_not have_css('.attributes_table th', :text => title)
end
