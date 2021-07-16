# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::AssetRegistration do
  include ActiveAdmin::AssetRegistration

  before do
    clear_stylesheets!
    clear_javascripts!
  end

  it "should register a stylesheet file" do
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
    expect(stylesheets.keys.first).to eq "active_admin.css"
  end

  it "should clear all existing stylesheets" do
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
    clear_stylesheets!
    expect(stylesheets).to be_empty
  end

  it "should allow media option when registering stylesheet" do
    register_stylesheet "active_admin.css", media: :print
    expect(stylesheets.values.first[:media]).to eq :print
  end

  it "shouldn't register a stylesheet twice" do
    register_stylesheet "active_admin.css"
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
  end

  it "should register a javascript file" do
    register_javascript "active_admin.js"
    expect(javascripts.keys).to eq ["active_admin.js"]
  end

  it "should clear all existing javascripts" do
    register_javascript "active_admin.js"
    expect(javascripts.keys).to eq ["active_admin.js"]
    clear_javascripts!
    expect(javascripts).to be_empty
  end

  it "shouldn't register a javascript twice" do
    register_javascript "active_admin.js"
    register_javascript "active_admin.js"
    expect(javascripts.size).to eq 1
  end
end
