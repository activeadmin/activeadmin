# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::LayoutHelper, type: :helper do
  describe "active_admin_application" do
    it "returns the application instance" do
      expect(helper.active_admin_application).to eq ActiveAdmin.application
    end
  end

  describe "set_page_title" do
    it "sets the @page_title variable" do
      helper.set_page_title("Sample Page")
      expect(helper.instance_variable_get(:@page_title)).to eq "Sample Page"
    end
  end

  describe "html_head_site_title" do
    before do
      expect(helper).to receive(:site_title).and_return("MyAdmin")
      allow(helper).to receive(:page_title).and_return("Users")
    end

    it "returns title in default format" do
      expect(helper.html_head_site_title).to eq "Users - MyAdmin"
    end

    it "returns title with custom separator" do
      expect(helper.html_head_site_title(separator: "|")).to eq "Users | MyAdmin"
    end

    it "returns title with @page_title override" do
      helper.set_page_title("Posts")
      expect(helper.html_head_site_title).to eq "Posts - MyAdmin"
    end
  end

  describe "skip_sidebar?" do
    it "should return true if skipped" do
      helper.skip_sidebar!
      expect(helper.skip_sidebar?).to eq true
    end

    it "should return false if not skipped" do
      expect(helper.skip_sidebar?).to eq false
    end
  end

  describe ".flash_messages" do
    it "should not include 'timedout' flash messages by default" do
      expect(helper).to receive(:active_admin_application).and_return(ActiveAdmin::Application.new)

      flash[:alert] = "Alert"
      flash[:timedout] = true
      expect(helper.flash_messages).to include "alert"
      expect(helper.flash_messages).to_not include "timedout"
    end

    it "should not return flash messages included in flash_keys_to_except config" do
      config = double(flash_keys_to_except: ["hideme"])
      expect(helper).to receive(:active_admin_application).and_return(config)

      flash[:alert] = "Alert"
      flash[:hideme] = "Do not show"
      expect(helper.flash_messages).to include "alert"
      expect(helper.flash_messages).to_not include "hideme"
    end
  end
end
