# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Pages::Base do
  class NewPage < ActiveAdmin::Views::Pages::Base
  end

  it "defines a default title" do
    expect(NewPage.new.title).to eq "NewPage"
  end

  it "defines default main content" do
    expect(NewPage.new.main_content).to eq "Please implement NewPage#main_content to display content."
  end

  describe "build_flash_messages" do
    class PageWithFlashMessages < ActiveAdmin::Views::Pages::Base
      def flash_messages
        { alert: "Alert message", notice: ["First notice message", "Second notice message"] }.with_indifferent_access
      end
    end

    it "shows all flash messages" do
      div = PageWithFlashMessages.new.send :build_flash_messages
      messages = div.get_elements_by_class_name("flash").map(&:content)
      expect(messages.first).to include("Alert message")
      expect(messages.second).to include("First notice message")
      expect(messages.third).to include("Second notice message")
    end
  end
end
