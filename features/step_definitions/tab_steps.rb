Then /^the "([^"]*)" tab should be selected$/ do |name|
  Then %{I should see "#{name}" within "ul#tabs li.current"}
end
