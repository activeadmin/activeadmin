Then /^I should see a flash with "([^"]*)"$/ do |text|
  Then %{I should see "#{text}"}
end
