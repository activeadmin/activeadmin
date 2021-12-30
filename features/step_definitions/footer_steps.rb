# frozen_string_literal: true
Around "@footer" do |scenario, block|
  previous_footer = ActiveAdmin.application.footer

  begin
    block.call
  ensure
    ActiveAdmin.application.footer = previous_footer
  end
end

Then /^I should see the default footer$/ do
  expect(page).to have_css "#footer", text: "Powered by Active Admin #{ActiveAdmin::VERSION}"
end

Then /^I should see the footer "([^"]*)"$/ do |footer|
  expect(page).to have_css "#footer", text: footer
end
