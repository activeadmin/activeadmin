Then /^I should not see pagination$/ do
  page.should_not have_css(".pagination")
end

Then /^I should see pagination with (\d+) pages$/ do |count|
  step %{I should see "#{count}" within ".pagination a"}
  step %{I should not see "#{count.to_i + 1}" within ".pagination a"}
end
