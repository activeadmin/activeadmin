Then /^the "([^"]*)" tab should be selected$/ do |name|
  step %{I should see "#{name}" within "ul#tabs li.current"}
end
