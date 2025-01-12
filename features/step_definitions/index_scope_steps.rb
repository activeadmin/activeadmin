# frozen_string_literal: true
Then(/^I should( not)? see the scope "([^"]*)"( selected)?$/) do |negate, name, selected|
  should = "I should#{' not' if negate}"
  scope = ".scopes#{' .index-button-selected' if selected}"
  step %{#{should} see "#{name}" within "#{scope}"}
end

Then(/^I should see the scope "([^"]*)" not selected$/) do |name|
  step %{I should see the scope "#{name}"}
  expect(page).to have_no_css ".scopes .index-button-selected", text: name
end

Then(/^I should see the scope "([^"]*)" with the count (\d+)$/) do |name, count|
  expect(page).to have_css ".scopes a", text: name
  expect(page).to have_css ".scopes-count", text: count
end

Then(/^I should see the scope with label "([^"]*)"$/) do |label|
  expect(page).to have_link(label)
end

Then(/^I should see the scope "([^"]*)" with no count$/) do |name|
  expect(page).to have_css ".scopes a", text: name
  expect(page).to have_no_css ".scopes-count"
end

Then "I should see a group {string} with the scopes {string} and {string}" do |group, name1, name2|
  group = group.tr(" ", "").underscore.downcase
  expect(page).to have_css ".scopes [data-group='#{group}'] a", text: name1
  expect(page).to have_css ".scopes [data-group='#{group}'] a", text: name2
end

Then "I should see a default group with a single scope {string}" do |name|
  expect(page).to have_css ".scopes [data-group=default] a", text: name
end

Then "I should not see any scopes" do
  expect(page).to have_no_css ".scopes a"
end
