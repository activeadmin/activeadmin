Given /^a configuration of:$/ do |config|
  ActiveAdmin.unload!
  File.open(ACTIVE_ADMIN_TEST_CONFIG, 'w+'){|f| f << config }
  Rails.application.reload_routes!
end
