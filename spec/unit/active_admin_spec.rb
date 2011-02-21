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
    ActiveAdmin.site_title.should == Rails.application.class.to_s.split('::').first
  end
  
  it "should set the site title" do
    old_title = ActiveAdmin.site_title.dup
    ActiveAdmin.site_title = "New Title"
    ActiveAdmin.site_title.should == "New Title"
    ActiveAdmin.site_title = old_title
  end

  it "should have a view factory" do
    ActiveAdmin.view_factory.should be_an_instance_of(ActiveAdmin::ViewFactory)
  end
  
  it "should have admin notes by default" do
    ActiveAdmin.admin_notes.should be_true
  end
  
  it "should have a default current_user_method" do
    ActiveAdmin.current_user_method.should == false
  end
  
end
