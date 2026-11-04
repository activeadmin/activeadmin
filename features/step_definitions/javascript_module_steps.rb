# frozen_string_literal: true
Around "@javascript_modules" do |scenario, block|
  previous_javascript_modules = ActiveAdmin.application.javascript_modules

  begin
    block.call
  ensure
    ActiveAdmin.application.javascript_modules = previous_javascript_modules
  end
end

def imported_javascript_modules
  page.all("script[type=module]", visible: false).map { |script| script.text(:all).squish }
end

Then(/^the page should import "([^"]*)"(?: followed by "([^"]*)")?$/) do |entry_point, modules|
  expected = [%(import "#{entry_point}")]
  expected << modules.split(", ").map { |name| %(import "#{name}") }.join(" ") if modules
  expect(imported_javascript_modules).to eq expected
end
