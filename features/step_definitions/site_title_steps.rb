# frozen_string_literal: true
Around "@site_title" do |scenario, block|
  previous_site_title = ActiveAdmin.application.site_title

  begin
    block.call
  ensure
    ActiveAdmin.application.site_title = previous_site_title
  end
end

Then(/^I should see the site title "([^"]*)"$/) do |title|
  expect(page).to have_css "[data-test-site-title]", text: title
end
