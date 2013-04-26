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
    MockRegistration.stylesheets.length.should == 1
    MockRegistration.stylesheets.keys.first.should == "active_admin.css"
  end

  it "should clear all existing stylesheets" do
    MockRegistration.register_stylesheet "active_admin.css"
    MockRegistration.stylesheets.length.should == 1
    MockRegistration.clear_stylesheets!
    MockRegistration.stylesheets.should be_empty
  end

  it "should allow media option when registering stylesheet" do
    MockRegistration.register_stylesheet "active_admin.css", :media => :print
    MockRegistration.stylesheets.values.first[:media].should == :print
  end

  it "shouldn't register a stylesheet twice" do
    MockRegistration.register_stylesheet "active_admin.css"
    MockRegistration.register_stylesheet "active_admin.css"
    MockRegistration.stylesheets.length.should == 1
  end


  it "should register a javascript file" do
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.javascripts.should == ["active_admin.js"].to_set
  end

  it "should clear all existing javascripts" do
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.javascripts.should == ["active_admin.js"].to_set
    MockRegistration.clear_javascripts!
    MockRegistration.javascripts.should be_empty
  end

  it "shouldn't register a javascript twice" do
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.register_javascript "active_admin.js"
    MockRegistration.javascripts.length.should == 1
  end
end
