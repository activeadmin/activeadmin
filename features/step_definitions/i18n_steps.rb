Given /^String "([^"]*)" corresponds to "([^"]*)"$/ do |translation, key|
  *seq, last_key = key.split('.')
  result = seq.reverse.inject({ last_key.to_sym => translation }) do |temp_result, nested_key|
    { nested_key.to_sym => temp_result }
  end
  I18n.backend.store_translations :en, active_admin: result
end

When /^I set my locale to "([^"]*)"$/ do |lang|
  I18n.locale = lang
end
