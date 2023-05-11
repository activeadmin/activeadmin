# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Resource::ActionItems do
  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  describe "adding a new action item" do
    before do
      resource.clear_action_items!
      resource.add_action_item :empty, class: :test do
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
      expect(resource.action_items.first.block).to_not eq nil
    end

    it "should include class from options" do
      expect(resource.action_items.first.html_class).to eq("action_item test")
    end

    it "should be ordered by priority" do
      resource.add_action_item :first, priority: 0 do
        # Empty ...
      end
      resource.add_action_item :some_other do
        # Empty ...
      end
      resource.add_action_item :second, priority: 1 do
        # Empty ...
      end

      expect(resource.action_items_for(:index).collect(&:name)).to eq [:first, :second, :empty, :some_other]
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
      expect do
        resource.action_items_for(:index).first.call
      end.to raise_exception(StandardError)
    end
  end

  describe "default action items" do
    it "should have 3 action items" do
      expect(resource.action_items.size).to eq 3
    end

    it "can be removed by name" do
      resource.remove_action_item :new
      expect(resource.action_items.size).to eq 2
    end
  end
end
