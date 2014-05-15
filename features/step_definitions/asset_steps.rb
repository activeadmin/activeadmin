Then /^I should see the css file "([^"]*)"$/ do |path|
  step %{I should see the css file "#{path}" of media "screen"}
end

Then /^I should see the css file "([^"]*)" of media "([^"]*)"$/ do |path, media|
  expect(page).to have_xpath "//link[contains(@href, /stylesheets/#{path}) and contains(@media, #{media})]"
end

Then /^I should see the js file "([^"]*)"$/ do |path|
  expect(page).to have_xpath "//script[contains(@src, /javascripts/#{path})]"
end

Then /^I should see the favicon "([^"]*)"$/ do |path|
  expect(page).to have_xpath "//link[contains(@href, \"#{path}\")]"
end
