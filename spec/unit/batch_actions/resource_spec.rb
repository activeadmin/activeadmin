require 'spec_helper'

describe ActiveAdmin::BatchActions::ResourceExtension do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.batch_actions = true
    namespace.register(Post)
  end
  
  describe "default action" do

    it "should have the default action by default" do
      resource.batch_actions.size.should == 1 and resource.batch_actions.first.sym == :destroy
    end

  end
  
  describe "adding a new batch action" do

    before do
      resource.clear_batch_actions!
      resource.add_batch_action :flag, "Flag" do
        # Empty
      end
    end

    it "should add an batch action" do
      resource.batch_actions.size.should == 1
    end

    it "should store an instance of BatchAction" do
      resource.batch_actions.first.should be_an_instance_of(ActiveAdmin::BatchAction)
    end

    it "should store the block in the batch action" do
      resource.batch_actions.first.block.should_not be_nil
    end

  end
  
  describe "removing batch action" do
    
    before do
      resource.remove_batch_action :destroy
    end
    
    it "should allow for batch action removal" do
      resource.batch_actions.size.should == 0
    end
    
  end

  describe "#batch_action_path" do

    it "returns the path as a symbol" do
      resource.batch_action_path.should == "/admin/posts/batch_action"
    end

  end

  describe "#display_if_block" do

    it "should return true by default" do
      action = ActiveAdmin::BatchAction.new :default, "Default"
      action.display_if_block.call.should == true
    end

    it "should return the :if block if set" do
      action = ActiveAdmin::BatchAction.new :with_block, "With Block", :if => proc { false } 
      action.display_if_block.call.should == false
    end

  end
  
  describe "batch action priority" do
    
    it "should have a default priority" do
      action = ActiveAdmin::BatchAction.new :default, "Default"
      action.priority.should == 10
    end
    
    it "should correctly order two actions" do
      priority_one = ActiveAdmin::BatchAction.new :one, "One", :priority => 1
      priority_ten = ActiveAdmin::BatchAction.new :ten, "Ten", :priority => 10
      priority_one.should be < priority_ten
    end
    
  end

end
