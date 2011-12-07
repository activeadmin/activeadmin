Then /^I should see an action item link to "([^"]*)"$/ do |link|
  page.should have_css('.action_item a', :text => link)
end
