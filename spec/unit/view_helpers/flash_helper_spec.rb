require 'rails_helper'

RSpec.describe ActiveAdmin::ViewHelpers::FlashHelper do

  describe '.flash_messages' do
    let(:view) { action_view }

    it "should not include 'timedout' flash messages by default" do
      view.request.flash[:alert] = "Alert"
      view.request.flash[:timedout] = true
      expect(view.flash_messages).to include 'alert'
      expect(view.flash_messages).to_not include 'timedout'
    end

    it "should not return flash messages included in flash_keys_to_except" do
      expect(view.active_admin_application).to receive(:flash_keys_to_except).and_return ["hideme"]
      view.request.flash[:alert] = "Alert"
      view.request.flash[:hideme] = "Do not show"
      expect(view.flash_messages).to include 'alert'
      expect(view.flash_messages).to_not include 'hideme'
    end

  end
end
