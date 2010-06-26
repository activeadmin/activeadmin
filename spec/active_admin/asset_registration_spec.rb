require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe ActiveAdmin do

  it "should register a stylesheet file" do
    ActiveAdmin.register_stylesheet "active_admin.css"
    ActiveAdmin.stylesheets.should == ["active_admin.css"]
  end

  it "should register a javascript file" do
    ActiveAdmin.register_javascript "active_admin.js"
    ActiveAdmin.javascripts.should == ["active_admin.js"]
  end
end
