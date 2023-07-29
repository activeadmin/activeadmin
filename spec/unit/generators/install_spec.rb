# frozen_string_literal: true
require "rails_helper"

RSpec.describe "AA installation" do
  context "should create" do
    it "active_admin.css" do
      path = Rails.root + "app/assets/stylesheets/active_admin.css"
      expect(File.exist?(path)).to eq true
    end

    it "active_admin.js" do
      path = Rails.root + "app/javascript/active_admin.js"
      expect(File.exist?(path)).to eq true
    end

    it "the dashboard" do
      path = Rails.root + "app/admin/dashboard.rb"

      expect(File.exist?(path)).to eq true
    end

    it "the initializer" do
      path = Rails.root + "config/initializers/active_admin.rb"

      expect(File.exist?(path)).to eq true
    end
  end
end
