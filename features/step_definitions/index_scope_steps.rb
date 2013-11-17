Then /^I should( not)? see the scope "([^"]*)"( selected)?$/ do |negate, name, selected|
  should = "I should#{' not' if negate}"
  scope = ".scopes#{' .selected' if selected}"
  step %{#{should} see "#{name}" within "#{scope}"}
end

Then /^I should see the scope "([^"]*)" not selected$/ do |name|
  step %{I should see the scope "#{name}"}
  page.should_not have_css('.scopes .selected', :text => name)
end

Then /^I should see the scope "([^"]*)" with the count (\d+)$/ do |name, count|
  name = name.gsub(' ','').underscore.downcase
  step %{I should see "#{count}" within ".scopes .#{name} .count"}
end

Then /^I should see the scope "([^"]*)" with no count$/ do |name|
  name = name.gsub(" ", "").underscore.downcase
  page.should     have_css(".scopes .#{name}")
  page.should_not have_css(".scopes .#{name} .count")
end
