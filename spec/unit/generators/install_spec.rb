require 'spec_helper'

describe "AA installation" do
  context "should create" do

    it "active_admin.css.scss" do
      File.exists?(Rails.root + "app/assets/stylesheets/active_admin.css.scss").should be_true
    end

    it "active_admin.js.coffee" do
      File.exists?(Rails.root + "app/assets/javascripts/active_admin.js.coffee").should be_true
    end

    it "the dashboard" do
      File.exists?(Rails.root + "app/admin/dashboard.rb").should be_true
    end

    it "the initializer" do
      File.exists?(Rails.root + "config/initializers/active_admin.rb").should be_true
    end

  end
end
