require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveAdmin do

  it "should have a default load path of ['app/admin']" do
    ActiveAdmin.load_paths.should == [File.expand_path('app/admin', Rails.root)]
  end

  it "should remove app/admin from the autoload path to remove the possibility of conflicts" do
    ActiveSupport::Dependencies.autoload_paths.should_not include(File.join(Rails.root, "app/admin"))
  end

  it "should remove app/admin from the eager load paths (Active Admin deals with loading)" do
    Rails.application.config.eager_load_paths.should_not include(File.join(Rails.root, "app/admin"))
  end
  
  it "should default the application name" do
    ActiveAdmin.site_title.should == "Rails300"
  end
  
  it "should set the site title" do
    old_title = ActiveAdmin.site_title.dup
    ActiveAdmin.site_title = "New Title"
    ActiveAdmin.site_title.should == "New Title"
    ActiveAdmin.site_title = old_title
  end

  it "should have a default tab renderer" do
    ActiveAdmin.tabs_renderer.should == ActiveAdmin::TabsRenderer
  end
  
  it "should have admin notes by default" do
    ActiveAdmin.admin_notes.should be_true
  end
  
  it "should have a default current_user_method" do
    ActiveAdmin.current_user_method.should == :current_admin_user
  end

  it "should have a default authentication method" do
	ActiveAdmin.authentication_method.should  == :authenticate_admin_user!
  end
  
end
