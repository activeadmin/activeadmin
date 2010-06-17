require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Describes "ActiveAdmin::ActionItems"
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

  # Store the config and set it back after each spec so that we
  # dont mess with other specs
  before do
    @config_before = Admin::PostsController.action_items
    Admin::PostsController.clear_action_items!
  end

  after(:each) do
    Admin::PostsController.action_items = @config_before
  end

  # Helpers method to define an action item
  def action_item(*args, &block)
    Admin::PostsController.class_eval do
      action_item *args, &block
    end
  end

  context "when setting with a block" do
    before do
      action_item do
        link_to "All Posts", collection_path
      end
      get :index
    end
    it "should add a new action item" do
      Admin::PostsController.action_items.size.should == 1
    end
    it "should render the content in the context of the view" do
      response.should have_tag('a', 'All Posts')
    end
  end

  # action_item 'New', new_post_path
  context "when setting with as a link with text and a path"

end
