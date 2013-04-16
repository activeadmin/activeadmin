Then /^I should see the site title "([^"]*)"$/ do |title|
  page.should have_css('h1#site_title', :text => title)
end

Then /^I should not see the site title "([^"]*)"$/ do |title|
  page.should_not have_css('h1#site_title', :text => title)
end

Then /^I should see the site title image "([^"]*)"$/ do |image|
  page.should have_css('h1#site_title img', :src => image)
end

Then /^I should see the site title image linked to "([^"]*)"$/ do |url|
  page.should have_css('h1#site_title a', :href => url)
end
