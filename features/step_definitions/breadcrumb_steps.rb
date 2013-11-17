Then /^I should see a link to "([^"]*)" in the breadcrumb$/ do |text|
  page.should have_css('.breadcrumb > a', :text => text)
end
