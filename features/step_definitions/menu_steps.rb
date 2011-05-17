Then /^I should see a menu item for "([^"]*)"$/ do |name|
  Then %{I should see "#{name}" within "#tabs li a"}
end

Then /^I should not see a menu item for "([^"]*)"$/ do |name|
  Then %{I should not see "#{name}" within "#tabs li a"}
end
