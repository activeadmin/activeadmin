Then /^I should see the site title "([^"]*)"$/ do |title|
  page.should have_css('h1#site_title', :text => title)
end

Then /^I should not see the site title "([^"]*)"$/ do |title|
  find('h1#site_title').should_not have_content title
end

Then /^I should see the site title image "([^"]*)"$/ do |image|
  page.should have_css "h1#site_title img[src='#{image}']"
end

Then /^I should see the site title image linked to "([^"]*)"$/ do |url|
  page.should have_css("h1#site_title a[href='#{url}']")
end


Then /^I should see the page title "([^"]*)"$/ do |title|
  find('h2#page_title').should have_content title
end

Then /^I should see the document title "([^"]*)"$/ do |title|
  page.title.should have_content title
end