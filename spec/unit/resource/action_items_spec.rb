require 'rails_helper'

describe ActiveAdmin::Resource::ActionItems do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  describe "adding a new action item" do

    before do
      resource.clear_action_items!
      resource.add_action_item :empty do
        # Empty ...
      end
    end

    it "should add an action item" do
      expect(resource.action_items.size).to eq 1
    end

    it "should store an instance of ActionItem" do
      expect(resource.action_items.first).to be_an_instance_of(ActiveAdmin::ActionItem)
    end

    it "should store the block in the action item" do
      expect(resource.action_items.first.block).to_not be_nil
    end

  end

  describe "setting an action item to only display on specific controller actions" do

    before do
      resource.clear_action_items!
      resource.add_action_item :new, only: :index do
        raise StandardError
      end
      resource.add_action_item :edit, only: :show do
        # Empty ...
      end
    end

    it "should return only relevant action items" do
      expect(resource.action_items_for(:index).size).to eq 1
      expect {
        resource.action_items_for(:index).first.call
      }.to raise_exception(StandardError)
    end

  end

  describe "default action items" do
    it "should have 3 action items" do
      expect(resource.action_items.size).to eq 3
    end

    it 'can be removed by name' do
      resource.remove_action_item :new
      expect(resource.action_items.size).to eq 2
    end
  end

end
