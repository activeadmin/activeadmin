Then /^I should see the scope "([^"]*)"$/ do |name|
  step %{I should see "#{name}" within ".scopes"}
end

Then /^I should not see the scope "([^"]*)"$/ do |name|
  step %{I should not see "#{name}" within ".scopes"}
end

Then /^I should see the scope "([^"]*)" selected$/ do |name|
  step %{I should see "#{name}" within ".scopes .selected"}
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  step %{I should see the scope "#{name}"}
  page.should_not have_css('.scopes .selected', :text => name)
end

Then /^I should see the scope "([^"]*)" with the count (\d+)$/ do |name, count|
  step %{I should see "#{count}" within ".scopes .#{name.gsub(" ", "").underscore.downcase} .count"}
end

Then /^I should see the scope "([^"]*)" with no count$/ do |name|
  page.should have_css(".scopes .#{name.gsub(" ", "").underscore.downcase}")
  page.should_not have_css(".scopes .#{name.gsub(" ", "").underscore.downcase} .count")
end

Then /^I should see (\d+) ([\w]*) in the table$/ do |count, resource_type|
  begin
    page.should have_css("table#index_table_#{resource_type} tr > td:first", :count => count.to_i)
  rescue
    current_count = 0

    all("table#index_table_#{resource_type} tr > td:first").each { current_count += 1 }

    raise "There were #{current_count} rows in the table not #{count}"
  end
end
