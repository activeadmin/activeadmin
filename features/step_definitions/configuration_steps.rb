module ActiveAdminReloading
  def load_aa_config(config_content)
    ActiveSupport::Notifications.publish ActiveAdmin::Application::BeforeLoadEvent, ActiveAdmin.application
    eval(config_content)
    ActiveSupport::Notifications.publish ActiveAdmin::Application::AfterLoadEvent, ActiveAdmin.application
    Rails.application.reload_routes!
    ActiveAdmin.application.namespaces.each &:reset_menu!
  end
end

World(ActiveAdminReloading)

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
      # :nocov:
      raise "#{resource} is not supported"
      # :nocov:
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
      # :nocov:
      raise "#{resource} is not supported"
      # :nocov:
    end
  end
end
