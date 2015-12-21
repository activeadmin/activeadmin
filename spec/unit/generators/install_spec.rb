require 'rails_helper'

describe "AA installation" do
  context "should create" do

    it "active_admin.scss" do
      path = Rails.root + "app/assets/stylesheets/active_admin.scss"
      expect(File.exists? path).to be_truthy
    end

    it "active_admin.js.coffee" do
      expect(File.exists?(Rails.root + "app/assets/javascripts/active_admin.js.coffee")).to be_truthy
    end

    it "the dashboard" do
      expect(File.exists?(Rails.root + "app/admin/dashboard.rb")).to be_truthy
    end

    it "the initializer" do
      expect(File.exists?(Rails.root + "config/initializers/active_admin.rb")).to be_truthy
    end

  end
end
