# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::ViewHelpers::SidebarHelper, type: :helper do
  describe "skip_sidebar?" do
    it "should return true if skipped" do
      helper.skip_sidebar!
      expect(helper.skip_sidebar?).to eq true
    end

    it "should return false if not skipped" do
      expect(helper.skip_sidebar?).to eq false
    end
  end
end
