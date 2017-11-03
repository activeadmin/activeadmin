Then /^I should see the css file "([^"]*)"$/ do |path|
  step %{I should see the css file "#{path}" of media "screen"}
end

Then /^I should see the css file "([^"]*)" of media "([^"]*)"$/ do |path, media|
  expect(page).to have_xpath("//link[contains(@href, '#{path}') and contains(@media, '#{media}')]", visible: false)
end

Then /^I should see the js file "([^"]*)"$/ do |path|
  expect(page).to have_xpath("//script[contains(@src, '#{path}')]", visible: false)
end

Then /^I should see the favicon "([^"]*)"$/ do |path|
  expect(page).to have_xpath("//link[contains(@href, '#{path}')]", visible: false)
end
