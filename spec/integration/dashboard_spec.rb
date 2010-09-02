require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveAdmin, "rendering the dashboard" do

  # Setup a controller spec
  include RSpec::Rails::ControllerExampleGroup
  render_views  
  metadata[:behaviour][:describes] = Admin::DashboardController

  before :all do
    load_defaults!
    reload_routes!
  end

  context "when no configuration" do
    before do
      get :index
    end
    it "should render the default message" do
      response.should have_tag("p", :attributes => { :id => "dashboard_default_message" })
    end
  end

  context "when one configuration" do
    before do
      ActiveAdmin.dashboard_section 'Hello World' do
        content_tag :p, "Hello world from the content"
      end
      get :index
    end
    it "should render the section's title" do
      response.should have_tag("h3", "Hello World")
    end
    it "should render the section's content" do
      response.should have_tag("p", "Hello world from the content")
    end
  end

  context "when many configurations" do
    it "should render each section"
    it "should render the sections by priority, then alpha"
  end

end
