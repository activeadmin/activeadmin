require 'spec_helper_without_rails'
require 'active_admin/menu'
require 'active_admin/menu_item'

include ActiveAdmin

describe ActiveAdmin::Menu do

  context "with no items" do

    it "should have an empty item collection" do
      menu = Menu.new
      menu.items.should be_empty
    end

    it "should accept new items" do
      menu = Menu.new
      item = MenuItem.new
      menu.add item
      menu.items.first.should == item
    end

  end

  context "with many item" do
    let(:menu) do
      Menu.new do |m|
        m.add MenuItem.new(:label => "Dashboard")
        m.add MenuItem.new(:label => "Blog")
      end
    end

    it "should give access to the menu item as an array" do
      menu['Dashboard'].label.should == 'Dashboard'
    end
  end

  describe Menu::ItemCollection do

    let(:collection) { Menu::ItemCollection.new }

    it "should initialize" do
      collection.should be_empty
    end

    describe "#find_by_id" do
      let(:menu_item) { MenuItem.new(:id => "an_id") }

      before do
        collection.push menu_item
      end

      it "retrieve an item id" do
        MenuItem.should_receive(:generate_item_id).with("an_id").and_return("an_id")
        collection.find_by_id("an_id").should == menu_item
      end

      it "returns nil when no matching ids" do
        collection.find_by_id("not matching").should == nil
      end

    end

  end

end

