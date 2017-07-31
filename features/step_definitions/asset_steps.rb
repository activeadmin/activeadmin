Then /^I should see the css file "([^"]*)"$/ do |path|
  expect(page).to have_xpath("//link[contains(@href, '#{path}') and contains(@media, 'screen')]", visible: false)
end

Then /^I should see the js file "([^"]*)"$/ do |path|
  expect(page).to have_xpath("//script[contains(@src, '#{path}')]", visible: false)
end

Then /^I should see the favicon "([^"]*)"$/ do |path|
  expect(page).to have_xpath("//link[contains(@href, '#{path}')]", visible: false)
end
