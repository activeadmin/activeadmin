require File.dirname(__FILE__) + '/../spec_helper'

include ActiveAdmin

describe ActiveAdmin::AdminController do
  
  include ActiveAdminIntegrationSpecHelper
  
  describe "when defining the index" do
    
    before(:each) do
      Admin::PostsController.reset_index_config!
    end
    
    it "should use the table builder by default" do
      Admin::PostsController.index_config.should be_an_instance_of(TableBuilder)
    end
    
    it 'should use a builder that you pass in' do
      class MyCustomBuilder; end
      Admin::PostsController.index :as => MyCustomBuilder
      Admin::PostsController.index_config.should be_an_instance_of(MyCustomBuilder)
      Admin::PostsController.index_config = nil
    end
    
  end
  
  it "should set the resource name" do
    Admin::PostsController.resource_name "My Post"
    Admin::PostsController.new.send(:resource_name).should == "My Post"
    Admin::PostsController.set_resource_name nil # Set it back for other specs
  end
  
  
end
