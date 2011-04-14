Then /^I should see a sidebar titled "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within ".sidebar_section h3"}
end

Then /^I should not see a sidebar titled "([^"]*)"$/ do |title|
  page.all(:css, "##{title.gsub(" ", '').underscore}_sidebar_section").count.should == 0
end

Then /^I should see \/([^\/]*)\/ within the sidebar "([^"]*)"$/ do |regexp, title|
  Then %{I should see /#{regexp}/ within "##{title.gsub(" ", '').underscore}_sidebar_section"}
end
