Then /^I should see a table header with "([^"]*)"$/ do |content|
  page.should have_xpath('//th', :text => content)
end

Then /^I should not see a table header with "([^"]*)"$/ do |content|
  page.should_not have_xpath('//th', :text => content)
end

Then /^I should see a sortable table header with "([^"]*)"$/ do |content|
  page.should have_css('th.sortable', :text => content)
end

Then /^I should not see a sortable table header with "([^"]*)"$/ do |content|
  page.should_not have_css('th.sortable', :text => content)
end

Then /^I should not see a sortable table header$/ do
  step %{I should not see "th.sortable"}
end

Then /^the table "([^"]*)" should have (\d+) rows/ do |selector, count|
  table = page.find(selector)
  table.all(:css, 'tr').size.should == count.to_i
end

Then /^the table "([^"]*)" should have (\d+) columns/ do |selector, count|
  table = page.find(selector)
  row = table.find('tr:first')
  row.all(:css, "td").size.should == count.to_i
end

Then /^there should be (\d+) "([^"]*)" tags$/ do |count, tag|
  page.all(:css, tag).size.should == count.to_i
end

Then /^I should see a link to "([^"]*)"$/ do |link|
  page.should have_xpath('//a', :text => link)
end

Then /^an "([^"]*)" exception should be raised when I follow "([^"]*)"$/ do |error, link|
  expect {
    step "I follow \"#{link}\""
  }.to raise_error(error.constantize)
end

Then /^I should be in the resource section for (.+)$/ do |resource_name|
  current_url.should include resource_name.gsub(' ', '').underscore.pluralize
end

Then /^I should wait and see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  sleep 1
  step 'show me the page'
  selector ||= "*"
  locate(:xpath, "//#{selector}[text()='#{text}']")
end

Then /^I should see the page title "([^"]*)"$/ do |title|
  within('h2#page_title') do
    page.should have_content(title)
  end
end

Then /^I should see a fieldset titled "([^"]*)"$/ do |title|
  page.should have_css('fieldset legend', :text => title)
end

Then /^the "([^"]*)" field should contain the option "([^"]*)"$/ do |field, option|
  field = find_field(field)
  field.should have_css("option", :text => option)
end

Then /^I should see the content "([^"]*)"$/ do |content|
  page.should have_css("#active_admin_content", :text => content)
end

Then /^I should see a validation error "([^"]*)"$/ do |error_message|
  page.should have_css(".inline-errors", :text => error_message)
end

Then /^I should see a table with id "([^"]*)"$/ do |dom_id|
  page.should have_css('table', :id => dom_id)
end
