# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Batch Actions Settings" do
  let(:app) { ActiveAdmin::Application.new }
  let(:ns) { ActiveAdmin::Namespace.new(app, "Admin") }
  let(:post_resource) { ns.register Post }

  it "should be disabled globally by default" do
    # Note: the default initializer would set it to true

    expect(app.batch_actions).to eq false
    expect(ns.batch_actions).to eq false
    expect(app.override_batch_action_selector_label).to eq false
    expect(ns.override_batch_action_selector_label).to eq false
    expect(post_resource.batch_actions_enabled?).to eq false
  end

  it "should be settable to true" do
    app.batch_actions = true
    app.override_batch_action_selector_label = true
    expect(app.batch_actions).to eq true
    expect(app.override_batch_action_selector_label).to eq true
  end

  it "should be an inheritable_setting" do
    app.batch_actions = true
    app.override_batch_action_selector_label = true
    expect(ns.batch_actions).to eq true
    expect(ns.override_batch_action_selector_label).to eq true
  end

  it "should be settable at the namespace level" do
    app.batch_actions = true
    ns.batch_actions = false
    app.override_batch_action_selector_label = true
    ns.override_batch_action_selector_label = false

    expect(app.batch_actions).to eq true
    expect(ns.batch_actions).to eq false
    expect(app.override_batch_action_selector_label).to eq true
    expect(ns.override_batch_action_selector_label).to eq false
  end

  it "should be settable at the resource level" do
    expect(post_resource.batch_actions_enabled?).to eq false
    expect(post_resource.override_batch_action_selector_label?).to eq false
    post_resource.batch_actions = true
    post_resource.override_batch_action_selector_label = true
    expect(post_resource.batch_actions_enabled?).to eq true
    expect(post_resource.override_batch_action_selector_label?).to eq true
  end

  it "should inherit the setting on the resource from the namespace" do
    ns.batch_actions = false
    ns.override_batch_action_selector_label = false
    expect(post_resource.batch_actions_enabled?).to eq false
    expect(post_resource.override_batch_action_selector_label?).to eq false
    expect(post_resource.batch_actions).to be_empty

    post_resource.batch_actions = true
    post_resource.override_batch_action_selector_label = true
    expect(post_resource.batch_actions_enabled?).to eq true
    expect(post_resource.override_batch_action_selector_label?).to eq true
    expect(post_resource.batch_actions).to_not be_empty
  end

  it "should inherit the setting from the namespace when set to nil" do
    ns.batch_actions = true

    post_resource.batch_actions = true
    expect(post_resource.batch_actions_enabled?).to eq true
    expect(post_resource.batch_actions).to_not be_empty

    post_resource.batch_actions = nil
    expect(post_resource.batch_actions_enabled?).to eq true # inherited from namespace
    expect(post_resource.batch_actions).to_not be_empty
  end
end
