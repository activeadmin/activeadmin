Then /^I should( not)? see the scope "([^"]*)"( selected)?$/ do |negate, name, selected|
  should = "I should#{' not' if negate}"
  scope = ".scopes#{' .selected' if selected}"
  step %{#{should} see "#{name}" within "#{scope}"}
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  step %{I should see the scope "#{name}"}
  expect(page).to_not have_css '.scopes .selected', text: name
end

Then /^I should see the scope "([^"]*)" with the count (\d+)$/ do |name, count|
  name = name.tr(' ', '').underscore.downcase
  step %{I should see "#{count}" within ".scopes .#{name} .count"}
end

Then /^I should see the scope with label "([^"]*)"$/ do |label|
  expect(page).to have_link(label)
end

Then /^I should see the current scope with label "([^"]*)"$/ do |label|
  expect(page).to have_css '.current_scope_name', text: label
end

Then /^I should see the scope "([^"]*)" with no count$/ do |name|
  name = name.tr(" ", "").underscore.downcase
  expect(page).to     have_css ".scopes .#{name}"
  expect(page).to_not have_css ".scopes .#{name} .count"
end
