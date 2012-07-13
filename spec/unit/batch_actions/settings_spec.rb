require 'spec_helper'

describe "Batch Actions Settings" do
  let(:app) { ActiveAdmin::Application.new }
  let(:ns) { ActiveAdmin::Namespace.new(app, "Admin") }
  let(:post_resource) { ns.register Post }

  it "should be disabled globally by default" do
    # Note: the default initializer would set it to true

    app.batch_actions.should be_false
    ns.batch_actions.should be_false
    post_resource.batch_actions_enabled?.should be_false
  end

  it "should be settable to true" do
    app.batch_actions = true
    app.batch_actions.should == true
  end

  it "should be an inheritable_setting" do
    app.batch_actions = true
    ns.batch_actions.should == true
  end

  it "should be settable at the namespace level" do
    app.batch_actions = true
    ns.batch_actions = false

    app.batch_actions.should == true
    ns.batch_actions.should == false
  end

  it "should be settable at the resource level" do
    post_resource.batch_actions_enabled?.should == false
    post_resource.batch_actions = true
    post_resource.batch_actions_enabled?.should == true
  end

  it "should inherit the setting on the resource from the namespace" do
    ns.batch_actions = false
    post_resource.batch_actions_enabled?.should == false
    post_resource.batch_actions.should be_empty

    post_resource.batch_actions = true
    post_resource.batch_actions_enabled?.should == true
    post_resource.batch_actions.should_not be_empty
  end

  it "should inherit the setting from the namespace when set to nil" do
    ns.batch_actions = true

    post_resource.batch_actions = true
    post_resource.batch_actions_enabled?.should == true
    post_resource.batch_actions.should_not be_empty

    post_resource.batch_actions = nil
    post_resource.batch_actions_enabled?.should == true # inherited from namespace
    post_resource.batch_actions.should_not be_empty
  end
end
