require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe ActiveAdmin::AssetRegistration do

  before do
    ActiveAdmin.clear_stylesheets!
    ActiveAdmin.clear_javascripts!
  end

  it "should register a stylesheet file" do
    ActiveAdmin.register_stylesheet "active_admin.css"
    ActiveAdmin.stylesheets.should == ["active_admin.css"]
  end

  it "should clear all existing stylesheets" do
    ActiveAdmin.register_stylesheet "active_admin.css"
    ActiveAdmin.stylesheets.should == ["active_admin.css"]    
    ActiveAdmin.clear_stylesheets!
    ActiveAdmin.stylesheets.should == []
  end

  it "should register a javascript file" do
    ActiveAdmin.register_javascript "active_admin.js"
    ActiveAdmin.javascripts.should == ["active_admin.js"]
  end

  it "should clear all existing javascripts" do
    ActiveAdmin.register_javascript "active_admin.js"
    ActiveAdmin.javascripts.should == ["active_admin.js"]    
    ActiveAdmin.clear_javascripts!
    ActiveAdmin.javascripts.should == []
  end
end
