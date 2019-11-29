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
        { alert: "Alert message", notice: ["First notice message", "Second notice message"] }
      end
    end

    it "shows all flash messages" do
      div = PageWithFlashMessages.new.send :build_flash_messages
      expect(div.get_elements_by_tag_name("div").map(&:content)).to contain_exactly("Alert message", "First notice message", "Second notice message")
    end
  end
end
