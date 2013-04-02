require 'spec_helper'
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
      menu.add :label => "Dashboard"
      menu.items.first.label.should == "Dashboard"
    end
  end

  context "with many items" do
    let(:menu) do
      Menu.new do |m|
        m.add :label => "Dashboard"
        m.add :label => "Blog"
      end
    end

    it "should give access to the menu item as an array" do
      menu['Dashboard'].label.should == 'Dashboard'
    end
  end

  describe "adding items with children" do
    it "should add an empty item if the parent does not exist" do
      menu = Menu.new
      menu.add :parent => "Admin", :label => "Users"

      menu["Admin"]["Users"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should add a child to a parent if it exists" do
      menu = Menu.new
      menu.add :parent => "Admin", :label => "Users"
      menu.add :parent => "Admin", :label => "Projects"

      menu["Admin"]["Projects"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should assign children regardless of resource file load order" do
      menu = Menu.new
      menu.add :parent => "Users", :label => "Posts"
      menu.add :label  => "Users", :url   => "/some/url"

      menu["Users"].url.should == "/some/url"
      menu["Users"]["Posts"].should be_a ActiveAdmin::MenuItem
    end
  end

  describe "sorting items" do
    it "should sort children by the result of their label proc" do
      menu = Menu.new
      menu.add :label => proc{ "G" }, :id => "not related 1"
      menu.add :label => proc{ "B" }, :id => "not related 2"
      menu.add :label => proc{ "A" }, :id => "not related 3"

      menu.items.map(&:label).should == %w[A B G]
    end
  end
end
