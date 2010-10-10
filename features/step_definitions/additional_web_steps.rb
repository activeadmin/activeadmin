Then /^I should see a table header with "([^"]*)"$/ do |content|
  Then "I should see \"#{content}\" within \"th\""
end

Then /^I should see a link to "([^"]*)"$/ do |link|
  Then "I should see \"#{link}\" within \"a\""
end
