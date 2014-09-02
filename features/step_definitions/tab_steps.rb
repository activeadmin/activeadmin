Then /^the "([^"]*)" tab should be selected$/ do |name|
  step %{I should see "#{name}" within ".navigation ul#tabs li.current"}
end

Then /^the "([^"]*)" secondary navigation tab should be selected$/ do |name|
  step %{I should see "#{name}" within ".subnav ul#tabs li.current"}
end
