module ActiveAdminReloading
  def load_aa_config(config_content)
    ActiveSupport::Notifications.publish ActiveAdmin::Application::BeforeLoadEvent, ActiveAdmin.application
    eval(config_content)
    ActiveSupport::Notifications.publish ActiveAdmin::Application::AfterLoadEvent,  ActiveAdmin.application
    Rails.application.reload_routes!
    ActiveAdmin.application.namespaces.each &:reset_menu!
  end
end

module ActiveAdminContentsRollback
  def files
    @files ||= {}
  end

  # Records the contents of a file the first time we are
  # about to change it
  def record(filename)
    contents        = File.read(filename) rescue nil
    files[filename] = contents            unless files.has_key? filename
  end

  # Rolls the recorded files back to their original states
  def rollback!
    files.each{ |file, contents| rollback_file(file, contents) }
    @files = {}
  end

  # If the file originally had content, override the stuff on disk.
  # Else, remove the file and its parent folder structure until Rails.root OR other files exist.
  def rollback_file(file, contents)
    if contents.present?
      File.open(file,'w') { |f| f << contents }
    else
      File.delete(file)
      begin
        dir = File.dirname(file)
        until dir == Rails.root
          Dir.rmdir(dir)                        # delete current folder
          dir = dir.split('/')[0..-2].join('/') # select parent folder
        end
      rescue Errno::ENOTEMPTY # Directory not empty
      end
    end
  end
end

World(ActiveAdminReloading)
World(ActiveAdminContentsRollback)

After do
  rollback!
end

Given /^a(?:n? (index|show))? configuration of:$/ do |action, config_content|
  load_aa_config(config_content)

  case action
  when 'index'
    step 'I am logged in'
    case resource = config_content.match(/ActiveAdmin\.register (\w+)/)[1]
    when 'Post'
      step 'I am on the index page for posts'
    when 'Category'
      step 'I am on the index page for categories'
    else
      raise "#{resource} is not supported"
    end
  when 'show'
    case resource = config_content.match(/ActiveAdmin\.register (\w+)/)[1]
    when 'Post'
      step 'I am logged in'
      step 'I am on the index page for posts'
      step 'I follow "View"'
    when 'Tag'
      step 'I am logged in'
      Tag.create!
      visit admin_tag_path Tag.last
    else
      raise "#{resource} is not supported"
    end
  end
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  path = Rails.root + filename
  FileUtils.mkdir_p File.dirname path
  record path

  File.open(path,'w+'){ |f| f << contents }
end

Given /^I add "([^"]*)" to the "([^"]*)" model$/ do |code, model_name|
  path = File.join Rails.root, "app", "models", "#{model_name}.rb"
  record path

  str = File.read(path).gsub /^(class .+)$/, "\\1\n  #{code}\n"
  File.open(path, 'w+') { |f| f << str }
  ActiveSupport::Dependencies.clear
end
