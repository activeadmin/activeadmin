# frozen_string_literal: true
Then(/^the "([^"]*)" tab should be selected$/) do |name|
  step %{I should see "#{name}" within "ul#tabs li.current"}
end

Then("I should see tabs:") do |table|
  table.rows.each do |title, _|
    expect(page).to have_css(".tabs .tabs-nav", text: title, visible: true)
  end
end

Then("I should see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content", text: string, visible: true)
end

Then("I should not see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content", text: string, visible: false)
end
