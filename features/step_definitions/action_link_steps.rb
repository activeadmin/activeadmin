# frozen_string_literal: true
Then(/^I should see a member link to "([^"]*)"$/) do |name|
  expect(page).to have_css(".data-table-resource-actions > a", text: name)
end

Then(/^I should not see a member link to "([^"]*)"$/) do |name|
  %{Then I should not see "#{name}" within ".data-table-resource-actions > a"}
end

Then(/^I should see the actions column with the class "([^"]*)" and the title "([^"]*)"$/) do |klass, title|
  expect(page).to have_css "th#{'.' + klass}", text: title
end
