require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAdmin do

  it "should have a default load path of ['app/active_admin']" do
    ActiveAdmin.load_paths.should == [File.expand_path('app/active_admin', Rails.root)]
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
  
end
