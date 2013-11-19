require 'spec_helper'

describe "Batch Actions Settings" do
  let(:app) { ActiveAdmin::Application.new }
  let(:ns) { ActiveAdmin::Namespace.new(app, "Admin") }
  let(:post_resource) { ns.register Post }

  it "should be disabled globally by default" do
    # Note: the default initializer would set it to true

    expect(app.batch_actions).to be_false
    expect(ns.batch_actions).to be_false
    expect(post_resource.batch_actions_enabled?).to be_false
  end

  it "should be settable to true" do
    app.batch_actions = true
    expect(app.batch_actions).to be_true
  end

  it "should be an inheritable_setting" do
    app.batch_actions = true
    expect(ns.batch_actions).to be_true
  end

  it "should be settable at the namespace level" do
    app.batch_actions = true
    ns.batch_actions = false

    expect(app.batch_actions).to be_true
    expect(ns.batch_actions).to be_false
  end

  it "should be settable at the resource level" do
    expect(post_resource.batch_actions_enabled?).to be_false
    post_resource.batch_actions = true
    expect(post_resource.batch_actions_enabled?).to be_true
  end

  it "should inherit the setting on the resource from the namespace" do
    ns.batch_actions = false
    expect(post_resource.batch_actions_enabled?).to be_false
    expect(post_resource.batch_actions).to be_empty

    post_resource.batch_actions = true
    expect(post_resource.batch_actions_enabled?).to be_true
    expect(post_resource.batch_actions).to_not be_empty
  end

  it "should inherit the setting from the namespace when set to nil" do
    ns.batch_actions = true

    post_resource.batch_actions = true
    expect(post_resource.batch_actions_enabled?).to be_true
    expect(post_resource.batch_actions).to_not be_empty

    post_resource.batch_actions = nil
    expect(post_resource.batch_actions_enabled?).to be_true # inherited from namespace
    expect(post_resource.batch_actions).to_not be_empty
  end
end
