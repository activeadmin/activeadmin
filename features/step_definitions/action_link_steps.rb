Then /^I should see a member link to "([^"]*)"$/ do |name|
  page.should have_css("a.member_link", :text => name)
end

Then /^I should not see a member link to "([^"]*)"$/ do |name|
  page.should_not have_css("a.member_link", :text => name)
end
