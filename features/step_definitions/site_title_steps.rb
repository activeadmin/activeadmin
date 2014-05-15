Then /^I should see the site title "([^"]*)"$/ do |title|
  expect(page).to have_css 'h1#site_title', text: title
end

Then /^I should not see the site title "([^"]*)"$/ do |title|
  expect(page).to_not have_css 'h1#site_title', text: title
end

Then /^I should see the site title image "([^"]*)"$/ do |image|
  expect(page).to have_css 'h1#site_title img', src: image
end

Then /^I should see the site title image linked to "([^"]*)"$/ do |url|
  expect(page).to have_css 'h1#site_title a', href: url
end
