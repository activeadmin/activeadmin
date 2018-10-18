require 'rails_helper'

RSpec.describe "AA installation" do
  context "should create" do

    it "active_admin.scss" do
      path = Rails.root + "app/assets/stylesheets/active_admin.scss"

      expect(File.exist?(path)).to eq true
    end

    it "active_admin.js.coffee" do
      path = Rails.root + "app/assets/javascripts/active_admin.js.coffee"

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
