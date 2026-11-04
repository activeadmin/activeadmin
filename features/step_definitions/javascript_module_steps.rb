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

Then(/^the page should import only the "([^"]*)" JavaScript module$/) do |entry_point|
  expect(imported_javascript_modules).to eq [%(import "#{entry_point}")]
end

Then(/^the page should import the JavaScript modules "([^"]*)" after "([^"]*)"$/) do |modules, entry_point|
  imports = modules.split(", ").map { |name| %(import "#{name}") }.join(" ")
  expect(imported_javascript_modules).to eq [%(import "#{entry_point}"), imports]
end
