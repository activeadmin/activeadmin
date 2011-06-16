Then /^I should see a sidebar titled "([^"]*)"$/ do |title|
  page.should have_css(".sidebar_section h3", :text => title)
end

Then /^I should not see a sidebar titled "([^"]*)"$/ do |title|
  page.all(:css, "##{title.gsub(" ", '').underscore}_sidebar_section").count.should == 0
end
