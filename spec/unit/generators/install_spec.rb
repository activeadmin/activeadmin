# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActiveAdmin Installation" do
  it "creates active_admin.css" do
    expect(File.exist?(Rails.root.join("app/assets/stylesheets/active_admin.css"))).to eq true
  end

  it "creates tailwind config file" do
    expect(File.exist?(Rails.root.join("tailwind-active_admin.config.mjs"))).to eq true
  end

  it "creates the dashboard resource" do
    expect(File.exist?(Rails.root.join("app/admin/dashboard.rb"))).to eq true
  end

  it "creates the config initializer" do
    expect(File.exist?(Rails.root.join("config/initializers/active_admin.rb"))).to eq true
  end
end
