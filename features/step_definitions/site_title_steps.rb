# frozen_string_literal: true
Around "@site_title" do |scenario, block|
  previous_site_title = ActiveAdmin.application.site_title
  previous_site_title_link = ActiveAdmin.application.site_title_link
  previous_site_title_image = ActiveAdmin.application.site_title_image

  begin
    block.call
  ensure
    ActiveAdmin.application.site_title = previous_site_title
    ActiveAdmin.application.site_title_link = previous_site_title_link
    ActiveAdmin.application.site_title_image = previous_site_title_image
  end
end

Then /^I should see the site title "([^"]*)"$/ do |title|
  expect(page).to have_css "h1#site_title", text: title
end

Then /^I should not see the site title "([^"]*)"$/ do |title|
  expect(page).to_not have_css "h1#site_title", text: title
end

Then /^I should see the site title image "([^"]*)"$/ do |image|
  img = page.find("h1#site_title img")
  expect(img[:src]).to eq(image)
end

Then /^I should see the site title image linked to "([^"]*)"$/ do |url|
  link = page.find("h1#site_title a")
  expect(link[:href]).to eq(url)
end
