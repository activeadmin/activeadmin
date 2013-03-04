Then /^I should see a menu item for "([^"]*)"$/ do |name|
  page.should have_css('#tabs > li > a', :text => name)
end

Then /^I should not see a menu item for "([^"]*)"$/ do |name|
  page.should_not have_css('#tabs > li > a', :text => name)
end

Then /^I should see "([^"]*)" as a child menu of "([^"]*)"$/ do |child, parent|
  parent.downcase!; child.downcase!
  page.should have_css("#tabs li##{parent} ul li##{child}")
end

Capybara.add_selector(:li) do
  xpath { |num| XPath.css("li:nth-child(#{num})") }
end

Then /^I should see "([^"]*)" after "([^"]*)"$/ do |first, second|
  within('#tabs') do
    find(:li, 1).text.should match(second)
    find(:li, 2).text.should match(first)
  end
end

Then /^"([^"]*)" should link to "([^"]*)"$/ do |item, url|
  find("#tabs li##{item.downcase}").should have_link(item, {:href => url})
end
