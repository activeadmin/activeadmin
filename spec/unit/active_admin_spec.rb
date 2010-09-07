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
  
  # TODO: Find a good way to test loading and unloading constants
  #       without blowing up all the other specs
  #
  #describe "loading" do
  #  it "should unload all registered controllers" do
  #    TestClass = Class.new(ActiveRecord::Base)
  #    ActiveAdmin.register(TestClass)
  #    Admin::TestClassesController
  #    ActiveAdmin.unload!
  #    lambda {
  #      Admin::TestClassesController
  #    }.should raise_error
  #    ActiveAdminIntegrationSpecHelper.load!
  #  end
  #end
  
  it "should default the application name" do
    ActiveAdmin.site_title.should == "Rails300"
  end
  
  it "should set the site title" do
    old_title = ActiveAdmin.site_title.dup
    ActiveAdmin.site_title = "New Title"
    ActiveAdmin.site_title.should == "New Title"
    ActiveAdmin.site_title = old_title
  end

  it "should have a set of menus" do
    ActiveAdmin.menus.should be_an_instance_of(Hash)
  end

  it "should have a default tab renderer" do
    ActiveAdmin.tabs_renderer.should == ActiveAdmin::TabsRenderer
  end
  
end
