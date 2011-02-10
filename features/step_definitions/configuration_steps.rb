Given /^a configuration of:$/ do |config|
  ActiveAdmin.unload!
  File.open(ACTIVE_ADMIN_TEST_CONFIG, 'w+'){|f| f << config }
  Rails.application.reload_routes!
end

Given /^an index configuration of:$/ do |config|
  ActiveAdmin.unload!
  File.open(ACTIVE_ADMIN_TEST_CONFIG, 'w+'){|f| f << config }
  Rails.application.reload_routes!

  And 'I am logged in'
  When "I am on the index page for posts"
end
