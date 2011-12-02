Then /^I should see the scope "([^"]*)"$/ do |name|
  Then %{I should see "#{name}" within ".scopes"}
end

Then /^I should not see the scope "([^"]*)"$/ do |name|
  Then %{I should not see "#{name}" within ".scopes"}
end

Then /^I should see the scope "([^"]*)" selected$/ do |name|
  Then %{I should see "#{name}" within ".scopes .selected"}
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  Then %{I should see the scope "#{name}"}
  page.should_not have_css('.scopes .selected', :text => name)
end

Then /^I should see the scope "([^"]*)" with the count (\d+)$/ do |name, count|
  Then %{I should see "#{count}" within ".scopes .#{name.gsub(" ", "").underscore.downcase} .count"}
end

Then /^I should see (\d+) ([\w]*) in the table$/ do |count, resource_type|
  begin
    page.should have_css("table##{resource_type} tr > td:first", :count => count.to_i)
  rescue
    current_count = 0
    
    all("table##{resource_type} tr > td:first").each { current_count += 1 }

    raise "There were #{current_count} rows in the table not #{count}"
  end
end
