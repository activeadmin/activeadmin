require 'spec_helper'

describe ActiveAdmin::AssetRegistration do
  include ActiveAdmin::AssetRegistration

  before do
    clear_stylesheets!
    clear_javascripts!
  end

  it "should register a stylesheet file" do
    register_stylesheet "active_admin.css"
    stylesheets.length.should == 1
    stylesheets.keys.first.should == "active_admin.css"
  end

  it "should clear all existing stylesheets" do
    register_stylesheet "active_admin.css"
    stylesheets.length.should == 1
    clear_stylesheets!
    stylesheets.should be_empty
  end

  it "should allow media option when registering stylesheet" do
    register_stylesheet "active_admin.css", media: :print
    stylesheets.values.first[:media].should == :print
  end

  it "shouldn't register a stylesheet twice" do
    register_stylesheet "active_admin.css"
    register_stylesheet "active_admin.css"
    stylesheets.length.should == 1
  end

  it "should register a javascript file" do
    register_javascript "active_admin.js"
    javascripts.should == ["active_admin.js"].to_set
  end

  it "should clear all existing javascripts" do
    register_javascript "active_admin.js"
    javascripts.should == ["active_admin.js"].to_set
    clear_javascripts!
    javascripts.should be_empty
  end

  it "shouldn't register a javascript twice" do
    register_javascript "active_admin.js"
    register_javascript "active_admin.js"
    javascripts.length.should == 1
  end
end
