require 'rails_helper'

RSpec.describe ActiveAdmin::AssetRegistration do
  include ActiveAdmin::AssetRegistration

  before do
    clear_stylesheets!
    clear_javascripts!
  end

  it "is deprecated" do
    expect(ActiveAdmin::Deprecation)
      .to receive(:warn)
      .with(<<-MSG.strip_heredoc
        The `register_stylesheet` config is deprecated and will be removed
        in v2. Import your "sample_styles.css" stylesheet in the active_admin.scss.
      MSG
      )

    register_stylesheet "sample_styles.css"

    expect(ActiveAdmin::Deprecation)
      .to receive(:warn)
      .with(<<-MSG.strip_heredoc
        The `register_javascript` config is deprecated and will be removed
        in v2. Import your "sample_scripts.js" javascript in the active_admin.js.
      MSG
      )

    register_javascript "sample_scripts.js"
  end

  it "should register a stylesheet file" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).once
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
    expect(stylesheets.keys.first).to eq "active_admin.css"
  end

  it "should clear all existing stylesheets" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).once
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
    clear_stylesheets!
    expect(stylesheets).to be_empty
  end

  it "should allow media option when registering stylesheet" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).once
    register_stylesheet "active_admin.css", media: :print
    expect(stylesheets.values.first[:media]).to eq :print
  end

  it "shouldn't register a stylesheet twice" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).twice
    register_stylesheet "active_admin.css"
    register_stylesheet "active_admin.css"
    expect(stylesheets.length).to eq 1
  end

  it "should register a javascript file" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).once
    register_javascript "active_admin.js"
    expect(javascripts).to eq ["active_admin.js"].to_set
  end

  it "should clear all existing javascripts" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).once
    register_javascript "active_admin.js"
    expect(javascripts).to eq ["active_admin.js"].to_set
    clear_javascripts!
    expect(javascripts).to be_empty
  end

  it "shouldn't register a javascript twice" do
    expect(ActiveAdmin::Deprecation).to receive(:warn).twice
    register_javascript "active_admin.js"
    register_javascript "active_admin.js"
    expect(javascripts.length).to eq 1
  end
end
