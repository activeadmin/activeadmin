Then /^I should see the scope "([^"]*)"$/ do |name|
  Then %{I should see "#{name}" within ".scopes"}
end

Then /^I should not see the scope "([^"]*)"$/ do |name|
  Then %{I should not see "#{name}" within ".scopes"}
end

Then /^I should see the scope "([^"]*)" selected$/ do |name|
  Then %{I should see "#{name}" within ".scopes li.selected"}
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  Then %{I should see the scope "#{name}"}
  page.should_not have_css('.scopes li.selected', :text => name)
end

Then /^I should see the scope "([^"]*)" with the count (\d+)$/ do |name, count|
  Then %{I should see "#{count}" within ".scopes .#{name.downcase} .count"}
end

Then /^I should see (\d+) ([\w]*) in the table$/ do |count, resource_type|
  page.should have_css("table##{resource_type} tr > td:first", :count => count.to_i)
end
