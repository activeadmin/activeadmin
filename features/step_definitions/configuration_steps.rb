Given /^a configuration of:$/ do |config|
  ActiveAdmin.unload!
  eval(config)
  ActiveAdmin.namespaces.values.each{|namespace| namespace.load_menu! }
  Rails.application.reload_routes!
end
