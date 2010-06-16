require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Describes "ActiveAdmin::Sidebar"
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

  # Store the config and set it back after each spec so that we
  # dont mess with other specs
  before do
    @config_before = Admin::PostsController.sidebar_sections
    Admin::PostsController.clear_sidebar_sections!
  end

  after(:each) do
    Admin::PostsController.sidebar_sections = @config_before
  end

  # Helper method to define a sidebar
  def sidebar(name, options = {}, &block)
    Admin::PostsController.class_eval do
      sidebar(name, options, &block)
    end    
  end

  context "when setting with a block" do
    before do
      sidebar :my_filters do
        link_to "My Filters", '#'
      end
      get :index
    end
    it "should add a new sidebar to @sidebar_sections" do
      Admin::PostsController.sidebar_sections.size.should == 1
    end
    it "should render content in the context of the view" do
      response.should have_tag("a", "My Filters")
    end
    it "should put a title for the section" do
      response.should have_tag("h3", "My Filters")
    end
  end

  context "when only adding to the index action" do
    before do
      sidebar(:filters, :only => :index){ }
    end
    it "should be available on index" do
      Admin::PostsController.sidebar_sections_for(:index).size.should == 1
    end
    it "should not be available on edit" do
      Admin::PostsController.sidebar_sections_for(:edit).size.should == 0
    end
  end

  context "when adding to all except index action" do
    before do
      sidebar(:filters, :except => :index){ }
    end
    it "should not be availbale on index" do
      Admin::PostsController.sidebar_sections_for(:index).size.should == 0
    end
    it "should be available on edit" do
      Admin::PostsController.sidebar_sections_for(:edit).size.should == 1
    end
  end

  context "when setting with a class"
  context "when setting with a partial"

end
