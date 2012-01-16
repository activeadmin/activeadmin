module ActiveAdminReloading

  def load_active_admin_configuration(configuration_content)
    eval(configuration_content)
    ActiveAdmin::Event.dispatch ActiveAdmin::Application::LoadEvent, ActiveAdmin.application
    Rails.application.reload_routes!
    ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }
  end

end

module ActiveAdminContentsRollback

  def self.recorded_files
    @files ||= {}
  end

  # Records the contents of a file the first time we are
  # about to change it
  def self.record(filename)
    recorded_files[filename] ||= File.read(filename)
  end

  # Rolls the recorded files back to their original states
  def self.rollback!
    recorded_files.each do |filename, contents|
      File.open(filename, "w+") do |f|
        f << contents
      end
    end
  end

end

World(ActiveAdminReloading)

After do
  ActiveAdminContentsRollback.rollback!
end

Given /^a configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)
  ActiveAdmin.application.namespaces.values.each{|n| n.load_menu! }
end

Given /^an index configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)

  step 'I am logged in'
  step "I am on the index page for posts"
end

Given /^a show configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)

  step 'I am logged in'
  step "I am on the index page for posts"
  step 'I follow "View"'
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  require 'fileutils'
  filepath = Rails.root + filename
  FileUtils.mkdir_p File.dirname(filepath)
  File.open(filepath, 'w+'){|f| f << contents }
end

Given /^I add "([^"]*)" to the "([^"]*)" model$/ do |code, model_name|
  filename = File.join(Rails.root, "app", "models", "#{model_name}.rb")
  ActiveAdminContentsRollback.record(filename)

  # Update the file
  contents = File.read(filename)
  File.open(filename, "w+") do |f|
    f << contents.gsub(/^(class .+)$/, "\\1\n  #{code}\n")
  end

  ActiveSupport::Dependencies.clear
end
