# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActiveAdmin Installation" do
  it "creates active_admin.css" do
    expect(File.exist?(Rails.root.join("app/assets/stylesheets/active_admin.css"))).to eq true
  end

  it "creates package.json" do
    expect(File.exist?(Rails.root.join("package.json"))).to eq true
  end

  it "creates tailwind.config.js" do
    expect(File.exist?(Rails.root.join("tailwind.config.js"))).to eq true
  end

  it "creates Procfile.dev" do
    expect(File.exist?(Rails.root.join("Procfile.dev"))).to eq true
  end

  it "creates a .keep file for app/assets/builds directory" do
    expect(File.exist?(Rails.root.join("app/assets/builds/.keep"))).to eq true
  end

  it "creates the dashboard resource" do
    expect(File.exist?(Rails.root.join("app/admin/dashboard.rb"))).to eq true
  end

  it "creates the config initializer" do
    expect(File.exist?(Rails.root.join("config/initializers/active_admin.rb"))).to eq true
  end
end
