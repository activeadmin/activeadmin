# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActiveAdmin Installation" do
  it "creates active_admin.css" do
    expect(Rails.root.join("app/assets/stylesheets/active_admin.css")).to exist
  end

  it "creates tailwind config file" do
    expect(Rails.root.join("tailwind-active_admin.config.js")).to exist
  end

  it "creates the dashboard resource" do
    expect(Rails.root.join("app/admin/dashboard.rb")).to exist
  end

  it "creates the config initializer" do
    expect(Rails.root.join("config/initializers/active_admin.rb")).to exist
  end
end
