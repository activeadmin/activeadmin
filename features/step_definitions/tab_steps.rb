Then(/^the "([^"]*)" tab should be selected$/) do |name|
  step %{I should see "#{name}" within "ul#tabs li.current"}
end

Then("I should see tabs:") do |table|
  table.rows.each do |title, _|
    step %{I should see "#{title}" within "#main_content .tabs .nav"}
  end
end

Then("I should see tab content {string}") do |string|
  step %{I should see "#{string}" within "#main_content .tabs .tab-content"}
end

Then("I should not see tab content {string}") do |string|
  step %{I should not see "#{string}" within "#main_content .tabs .tab-content"}
end
