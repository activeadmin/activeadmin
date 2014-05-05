require 'spec_helper'

describe "AA installation" do
  def current_version
    detect_rails_version if File.exists?('Gemfile.lock')
  end

  context "should create" do
    it "active_admin.css.scss" do
      if (current_version != '4.1.0')
        expect(File.exists?(Rails.root + "app/assets/stylesheets/active_admin.css.scss")).to be_true
      else
        expect(File.exists?(Rails.root + "vendor/assets/stylesheets/active_admin.css.scss")).to be_true
      end
    end

    it "active_admin.js.coffee" do
      if (current_version != '4.1.0')
        expect(File.exists?(Rails.root + "app/assets/javascripts/active_admin.js.coffee")).to be_true
      else
        expect(File.exists?(Rails.root + "vendor/assets/javascripts/active_admin.js.coffee")).to be_true
      end
    end

    it "the dashboard" do
      expect(File.exists?(Rails.root + "app/admin/dashboard.rb")).to be_true
    end

    it "the initializer" do
      expect(File.exists?(Rails.root + "config/initializers/active_admin.rb")).to be_true
    end

  end
end
