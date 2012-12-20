Then /^I should see the scope "([^"]*)"$/ do |name|
  page.should have_css(".scopes .scope", :text => name)
end

Then /^I should not see the scope "([^"]*)"$/ do |name|
  page.should_not have_css(".scopes .scope", :text => name)
end

Then /^I should see the scope "([^"]*)" selected$/ do |name|
  page.should have_css(".scopes .scope.active", :text => name)
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  page.should have_css(".scopes .scope", :text => name)
  page.should_not have_css('.scopes .active', :text => name)
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
    page.should have_css("table##{resource_type} tr > td:first", :count => count.to_i)
  rescue
    current_count = 0
    
    all("table##{resource_type} tr > td:first").each { current_count += 1 }

    raise "There were #{current_count} rows in the table not #{count}"
  end
end
