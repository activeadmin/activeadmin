Then /^I should not see pagination$/ do
  page.should_not have_css(".pagination")
end

Then /^I should see pagination with (\d+) pages$/ do |count|
  page.should have_css(".pagination a", :text => count)
  page.should_not have_css(".pagination a", :text => (count.to_i + 2).to_s)
end
