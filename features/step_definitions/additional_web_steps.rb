Then /^I should see a table header with "([^"]*)"$/ do |content|
  Then "I should see \"#{content}\" within \"th\""
end

Then /^I should not see a table header with "([^"]*)"$/ do |content|
  Then "I should not see \"#{content}\" within \"th\""
end

Then /^I should see a sortable table header with "([^"]*)"$/ do |content|
  Then "I should see \"#{content}\" within \"th.sortable\""
end

Then /^the table "([^"]*)" should have (\d+) rows/ do |selector, count|
  with_scope(selector) do
    page.all(:css, 'tr').size.should == count.to_i
  end
end

Then /^the table "([^"]*)" should have (\d+) columns/ do |selector, count|
  with_scope(selector + " tr:first") do
    page.all(:css, "td").size.should == count.to_i
  end
end

Then /^there should be (\d+) "([^"]*)" tags within "([^"]*)"$/ do |count, tag, selector|
  with_scope(selector) do
    page.all(:css, tag).size.should == count.to_i
  end
end

Then /^I should see a link to "([^"]*)"$/ do |link|
  Then "I should see \"#{link}\" within \"a\""
end

Then /^I should see a link to \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if page.respond_to? :should
    page.should have_xpath('//a', :text => regexp)
  else
    assert page.has_xpath?('//a', :text => regexp)
  end
end

Then /^an "([^"]*)" exception should be raised when I follow "([^"]*)"$/ do |error, link|
  lambda {
    When "I follow \"#{link}\""
  }.should raise_error(error.constantize)
end

Then /^I should be in the resource section for (.+)$/ do |resource_name|
  current_url.should include(resource_name.gsub(' ', '').underscore.pluralize)
end

Then /^I should wait and see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  sleep 1
  Then 'show me the page'
  selector ||= "*"
  locate(:xpath, "//#{selector}[text()='#{text}']")
end

Then /^I should see the page title "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within "h2#page_title"}
end

Then /^I should see a fieldset titled "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within "fieldset legend"}
end
