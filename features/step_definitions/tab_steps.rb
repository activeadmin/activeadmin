# frozen_string_literal: true
Then(/^the "([^"]*)" tab should be selected$/) do |name|
  step %{I should see "#{name}" within "ul#tabs li.current"}
end

Then("I should see tabs:") do |table|
  table.rows.each do |title, _|
    expect(page).to have_css(".tabs .tabs-nav :not(.hidden)", text: title)
  end
end

Then("I should see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content :not(.hidden)", text: string)
end

Then("I should not see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content .hidden", text: string)
end
