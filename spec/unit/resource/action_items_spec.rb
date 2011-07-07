require 'spec_helper'

describe ActiveAdmin::Resource::ActionItems do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  describe "adding a new action item" do

    before do
      resource.clear_action_items!
      resource.add_action_item do
        # Empty ...
      end
    end

    it "should add an action item" do
      resource.action_items.size.should == 1
    end

    it "should store an instance of ActionItem" do
      resource.action_items.first.should be_an_instance_of(ActiveAdmin::ActionItem)
    end

    it "should store the block in the action item" do
      resource.action_items.first.block.should_not be_nil
    end

  end

  describe "setting an action item to only display on specific controller actions" do

    before do
      resource.clear_action_items!
      resource.add_action_item :only => :index do
        raise StandardError
      end
      resource.add_action_item :only => :show do
        # Empty ...
      end
    end

    it "should return only relevant action items" do
      resource.action_items_for(:index).size.should == 1
      lambda {
        resource.action_items_for(:index).first.call
      }.should raise_exception(StandardError)
    end

  end

  describe "default action items" do

    it "should have 3 action items" do
      resource.action_items.size.should == 3
    end

  end

end
