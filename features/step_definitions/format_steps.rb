Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should see the attribute "([^"]*)" with a nicely formatted datetime$/ do |title|
  Then "I should see \"#{title}\" within \"table.resource_attributes th\""
  # TODO scope this check
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

