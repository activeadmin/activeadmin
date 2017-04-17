require 'uri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step_name, parent|
  with_scope(parent) { step step_name }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step_name, parent, table_or_string|
  with_scope(parent) { step "#{step_name}:", table_or_string }
end

Given /^(?:I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:I )follow "([^"]*)"$/ do |link|
  first(:link, link).click
end

When /^(?:I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^(?:I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, from: field)
end

When /^(?:I )(check|uncheck|choose) "([^"]*)"$/ do |action, field|
  send action, field
end

When /^(?:I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

Then /^(?:I )should( not)? see( the element)? "([^"]*)"$/ do |negate, is_css, text|
  should = negate ? :not_to        : :to
  have   = is_css ? have_css(text) : have_content(text)
  expect(page).send should, have
end

Then /^the "([^"]*)" field(?: within (.*))? should( not)? contain "([^"]*)"$/ do |field, parent, negate, value|
  with_scope(parent) do
    field = find_field(field)
    value = field.tag_name == 'textarea' ? field.text : field.value

    expect(value).send negate ? :not_to : :to, match(/#{value}/)
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should( not)? be checked$/ do |label, parent, negate|
  with_scope(parent) do
    checkbox = find_field(label)
    if negate
      expect(checkbox).not_to be_checked
    else
      expect(checkbox).to be_checked
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  expect(URI.parse(current_url).path).to eq path_to page_name
end

Then /^show me the page$/ do
  save_and_open_page
end
