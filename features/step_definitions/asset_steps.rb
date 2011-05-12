Then /^I should see the css file "([^"]*)"$/ do |path|
  page.should have_xpath("//link[contains(@href, /stylesheets/#{path})]")
end

Then /^I should see the js file "([^"]*)"$/ do |path|
  page.should have_xpath("//script[contains(@src, /javascripts/#{path})]")
end
