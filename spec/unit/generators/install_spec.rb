require 'spec_helper'

describe "AA installation" do
  context "should create" do

    it "active_admin.css.scss" do
      expect(File.exists?(Rails.root + "app/assets/stylesheets/active_admin.css.scss")).to be_true
    end

    it "active_admin.js.coffee" do
      expect(File.exists?(Rails.root + "app/assets/javascripts/active_admin.js.coffee")).to be_true
    end

    it "the dashboard" do
      expect(File.exists?(Rails.root + "app/admin/dashboard.rb")).to be_true
    end

    it "the initializer" do
      expect(File.exists?(Rails.root + "config/initializers/active_admin.rb")).to be_true
    end

  end
end
