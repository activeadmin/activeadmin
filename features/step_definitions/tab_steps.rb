# frozen_string_literal: true
Then("I should see tabs:") do |table|
  table.rows.each do |title, _|
    expect(page).to have_css(".tabs .tabs-nav :not(.hidden)", text: title)
  end
end

Then("I should see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content :not(.hidden)", text: string)
end

Then("I should not see tab content {string}") do |string|
  expect(page).to have_css(".tabs .tabs-content .hidden", text: string, visible: :hidden)
end
