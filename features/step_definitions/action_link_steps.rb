Then /^I should see a member link to "([^"]*)"$/ do |name|
  page.should have_css("a.member_link", text: name)
end

Then /^I should not see a member link to "([^"]*)"$/ do |name|
  %{Then I should not see "#{name}" within "a.member_link"}
end

Then /^I should see the actions column with the class "([^"]*)" and the title "([^"]*)"$/ do |klass, title|
  page.should have_css "th#{'.'+klass}", text: title
end
