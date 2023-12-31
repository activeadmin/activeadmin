# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::LayoutHelper, type: :helper do
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
