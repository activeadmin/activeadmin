Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should see a link to download "([^"]*)"$/ do |format_type|
  Then %{I should see "#{format_type}" within "#index_footer a"}
end
