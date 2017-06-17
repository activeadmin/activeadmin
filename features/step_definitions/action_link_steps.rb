Then /^I should see a member link to "([^"]*)"$/ do |name|
  expect(page).to have_css('a.member_link', text: name)
end

Then /^I should not see a member link to "([^"]*)"$/ do |name|
  %{Then I should not see "#{name}" within "a.member_link"}
end

Then /^I should see the actions column with the class "([^"]*)" and the title "([^"]*)"$/ do |klass, title|
  expect(page).to have_css "th#{'.'+klass}", text: title
end

Then /^I should see a dropdown menu item to "([^"]*)"$/ do |name|
  expect(page).to have_css('ul.dropdown_menu_list li a', text: name)
end

Then /^I should not see a dropdown menu item to "([^"]*)"$/ do |name|
  %{Then I should not see "#{name}" within "ul.dropdown_menu_list li a"}
end
