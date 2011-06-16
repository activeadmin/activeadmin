Then /^I should see the attribute "([^"]*)" with "([^"]*)"$/ do |title, value|
  page.should have_css('.attributes_table th', :text => title)
  page.should have_css('.attributes_table td', :text => value)
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  page.should have_css('.attributes_table th', :text => title)
  with_scope ".attributes_table td" do
    page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
  end
end

Then /^I should not see the attribute "([^"]*)"$/ do |title|
  page.should_not have_css('.attributes_table th', :text => title)
end
