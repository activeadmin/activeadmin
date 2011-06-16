Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  page.should have_css('.attributes_table th', :text => title)
  page.should have_css('.attributes_table td', :text => value)
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  th = page.find('.attributes_table th', :text => title)
  page.find(:xpath, th.path.gsub(/th$/, 'td')).text.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should not see the attribute "([^"]*)"$/ do |title|
  page.should_not have_css('.attributes_table th', :text => title)
end
