Given /^a configuration of:$/ do |configuration_content|
  eval configuration_content
  Rails.application.reload_routes!
  ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }
end

Given /^an index configuration of:$/ do |configuration_content|
  eval configuration_content
  Rails.application.reload_routes!
  ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }

  And 'I am logged in'
  When "I am on the index page for posts"
end

Given /^a show configuration of:$/ do |configuration_content|
  eval configuration_content
  Rails.application.reload_routes!
  ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }

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
