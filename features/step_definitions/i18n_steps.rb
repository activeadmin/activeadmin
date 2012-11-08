When /^I set my locale to "([^"]*)"$/ do |lang|
  I18n.locale = lang
end
