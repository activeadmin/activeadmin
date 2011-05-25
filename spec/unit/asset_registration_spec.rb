require 'spec_helper' 

module MockRegistration
  extend ActiveAdmin::AssetRegistration
end

describe ActiveAdmin::AssetRegistration do

  before do
    MockRegistration.clear_stylesheets!
    MockRegistration.clear_javascripts!
  end

  it "should register a stylesheet file" do
    MockRegistration.register_stylesheet "active_admin.css"
    MockRegistration.stylesheets.should == ["active_admin.css"]
  end

  it "should clear all existing stylesheets" do
    MockRegistration.register_stylesheet "active_admin.css"
    MockRegistration.stylesheets.should == ["active_admin.css"]    
    MockRegistration.clear_stylesheets!
    MockRegistration.stylesheets.should == []
  end

  it "should register a javascript file" do
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.javascripts.should == ["active_admin.js"]
  end

  it "should clear all existing javascripts" do
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.javascripts.should == ["active_admin.js"]    
    MockRegistration.clear_javascripts!
    MockRegistration.javascripts.should == []
  end
end
