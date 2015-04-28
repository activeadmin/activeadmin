Then /^the site should contain a meta tag with name "([^"]*)" and content "([^"]*)"$/ do |name, content|
  expect(page).to have_xpath("//meta[@name='#{name}' and @content='#{content}']", visible: false)
end
