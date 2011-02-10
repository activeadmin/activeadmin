Then /^I should see a table header with "([^"]*)"$/ do |content|
  Then "I should see \"#{content}\" within \"th\""
end

Then /^I should see a link to "([^"]*)"$/ do |link|
  Then "I should see \"#{link}\" within \"a\""
end

Then /^I should see a link to \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if page.respond_to? :should
    page.should have_xpath('//a', :text => regexp)
  else
    assert page.has_xpath?('//a', :text => regexp)
  end
end

Then /^an "([^"]*)" exception should be raised when I follow "([^"]*)"$/ do |error, link|
  lambda {
    When "I follow \"#{link}\""
  }.should raise_error(error.constantize)
end
