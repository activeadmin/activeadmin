# frozen_string_literal: true
require "uri"
require File.expand_path(File.join(__dir__, "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end

  private

  def selector_for(locator)
    case locator

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /^the (notice|error|info) flash$/
    #    ".flash.#{$1}"

    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    when /^the "([^"]*)" sidebar$/
      [:css, "##{$1.tr(" ", '').underscore}_sidebar_section"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /^"(.+)"$/
      $1

    else
      # simplecov:disable
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
      # simplecov:enable
    end
  end
end
World(WithinHelpers)

Given(/^I am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^I go to (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^I press "([^"]*)"$/) do |button|
  click_on(button)
end

When(/^I follow "([^"]*)"$/) do |link|
  first(:link, link).click
end

When(/^I click "(.*?)"$/) do |link|
  click_on(link)
end

When(/^I (check|uncheck) "([^"]*)"$/) do |action, field|
  send action, field
end

Then(/^I should( not)? see( the element)? "([^"]*)"$/) do |negate, is_css, text|
  should = negate ? :not_to : :to
  have = is_css ? have_css(text) : have_text(text)
  expect(page).send should, have
end

Then(/^I should see the field "([^"]*)" of type "([^"]+)"?$/) do |label, of_type|
  expect(page).to have_field(label, type: of_type)
end

Then(/^I should see a flash with "([^"]*)"$/) do |text|
  expect(page).to have_text text
end
