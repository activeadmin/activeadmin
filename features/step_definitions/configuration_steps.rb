module ActiveAdminReloading

  def load_active_admin_configuration(configuration_content)
    eval(configuration_content)
    ActiveAdmin::Event.dispatch ActiveAdmin::Application::LoadEvent, ActiveAdmin.application
    Rails.application.reload_routes!
    ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }
  end

end

World(ActiveAdminReloading)

Given /^a configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)
  ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }
end

Given /^an index configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)

  And 'I am logged in'
  When "I am on the index page for posts"
end

Given /^a show configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)

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
