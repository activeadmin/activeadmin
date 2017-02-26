require 'rails_helper'

RSpec.describe ActiveAdmin::Views::UnsupportedBrowser do
  let(:helpers){ mock_action_view }
  let(:namespace) { double :namespace, unsupported_browser_matcher: /MSIE [1-8]\.0/ }
  let(:component) { double :unsupported_browser_component }
  let(:view_factory) { double :view_factory, unsupported_browser: component }
  let(:base) { ActiveAdmin::Views::Pages::Base.new }

  def build_panel
    render_arbre_component({}, helpers) do
      insert_tag ActiveAdmin::Views::UnsupportedBrowser
    end
  end

  it "should render the panel" do
    expect(I18n).to receive(:t).and_return("headline", "recommendation" , "turn_off_compatibility_view")
    expect(build_panel.content.gsub(/\s+/, "")).to eq "<h1>headline</h1><p>recommendation</p><p>turn_off_compatibility_view</p>"
  end

  describe "ActiveAdmin::Views::Pages::Base behavior" do
    context "when the reqex match" do
      it "should build the unsupported browser panel" do
        expect(base).to receive(:active_admin_namespace).and_return(namespace)
        expect(base).to receive_message_chain(:controller, :request, :user_agent).and_return("Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.2; Trident/6.0)")
        expect(base).to receive(:view_factory).and_return(view_factory)
        expect(base).to receive(:insert_tag).with(component)
        base.send(:build_unsupported_browser)
      end
    end

    context "when the regex not match" do
      it "should not build the unsupported browser panel" do
        expect(base).to receive(:active_admin_namespace).and_return(namespace)
        expect(base).to receive_message_chain(:controller, :request, :user_agent).and_return("Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)")
        expect(base).to receive(:insert_tag).never
        base.send(:build_unsupported_browser)
      end
    end
  end
end
