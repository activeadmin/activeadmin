module ActiveAdminReloading

  def load_active_admin_configuration(configuration_content)
    ActiveAdmin::Event.dispatch ActiveAdmin::Application::BeforeLoadEvent, ActiveAdmin.application
    eval(configuration_content)
    ActiveAdmin::Event.dispatch ActiveAdmin::Application::AfterLoadEvent, ActiveAdmin.application
    Rails.application.reload_routes!
    ActiveAdmin.application.namespaces.values.each{|n| n.reset_menu! }
  end

end

module ActiveAdminContentsRollback

  def self.recorded_files
    @files ||= {}
  end

  # Records the contents of a file the first time we are
  # about to change it
  def self.record(filename)
    contents = File.read(filename) rescue nil
    recorded_files[filename] = contents unless recorded_files.has_key?(filename)
  end

  # Rolls the recorded files back to their original states
  def self.rollback!
    recorded_files.each do |filename, contents|
      # contents will be nil if the file didin't exist
      if contents.present?
        File.open(filename, "w") {|f| f << contents }
      else
        File.delete(filename)

        # Delete parent directories
        begin
          dir = File.dirname(filename)
          until dir == Rails.root
            Dir.rmdir(dir)
            dir = dir.split('/')[0..-2].join('/')
          end
        rescue Errno::ENOTEMPTY
          # Directory not empty
        end

      end
    end

    @files = {}
  end

end

World(ActiveAdminReloading)

After do
  ActiveAdminContentsRollback.rollback!
end

Given /^a configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)
end

Given /^an index configuration of:$/ do |configuration_content|
  load_active_admin_configuration(configuration_content)

  step 'I am logged in'
  step "I am on the index page for posts"
end

Given /^a show configuration of:$/ do |configuration_content|
  resource = configuration_content.match(/ActiveAdmin\.register (\w+)/)[1]
  load_active_admin_configuration(configuration_content)

  case resource
  when "Post"
    step 'I am logged in'
    step "I am on the index page for posts"
    step 'I follow "View"'
  when "Tag"
    step 'I am logged in'
    Tag.create!
    visit admin_tag_path(Tag.last)
  else
    raise "#{resource} is not supported"
  end
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  require 'fileutils'
  filepath = Rails.root + filename
  FileUtils.mkdir_p File.dirname(filepath)
  ActiveAdminContentsRollback.record(filepath)

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
