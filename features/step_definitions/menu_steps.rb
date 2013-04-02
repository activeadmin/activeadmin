Then /^I should see a menu item for "([^"]*)"$/ do |name|
  page.should have_css('#tabs li a', :text => name)
end

Then /^I should not see a menu item for "([^"]*)"$/ do |name|
  page.should_not have_css('#tabs li a', :text => name)
end

Then /^I should see a nested menu item for "([^"]*)"$/ do |name|
  page.should have_css('#tabs > li > ul > li > a', :text => name)
end
