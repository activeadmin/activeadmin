Then /^I should see a flash with "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see a successful create flash$/ do
  page.should have_css('div.flash_notice', :text => /was successfully created/)
end

Then /^I should not see a successful create flash$/ do
  page.should_not have_css('div.flash_notice', :text => /was successfully created/)
end
