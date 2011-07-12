require 'spec_helper'


if Rails.version[0..2] == '3.1'
  describe "Installing in Rails 3.1" do

    it "should add active_admin.css to app/assets/stylesheets/" do
      File.exists?(Rails.root + "app/assets/stylesheets/active_admin.css.scss").should be_true
    end

    it "should add active_admin.js to app/assets/javascripts" do
      File.exists?(Rails.root + "app/assets/javascripts/active_admin.js").should be_true
    end

  end
end
