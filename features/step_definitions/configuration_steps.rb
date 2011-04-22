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

Given /^a show configuration of:$/ do |config|
  ActiveAdmin.unload!
  File.open(ACTIVE_ADMIN_TEST_CONFIG, 'w+'){|f| f << config }
  Rails.application.reload_routes!

  And 'I am logged in'
  When "I am on the index page for posts"
  And 'I follow "View"'
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  require 'fileutils'
  filepath = Rails.root + filename
  FileUtils.mkdir_p File.dirname(filepath)
  File.open(filepath, 'w+'){|f| f << contents }
end
