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

  context "with many item" do
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
      menu.add :parent => "Admin", :label  => "Users"

      menu["Admin"]["Users"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should add a child to a parent if it exists" do
      menu = Menu.new
      menu.add :parent => "Admin", :label  => "Users"
      menu.add :parent => "Admin", :label  => "Projects"

      menu["Admin"]["Projects"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end
  end

  describe "sorting items" do
    def build_label_proc(label)
      proc {|label| label }
    end

    it "should sort children by the result of their label proc" do
      menu = Menu.new
      blog_post_menu = menu.add :label => build_label_proc("Blog posts")
      user_menu = menu.add :label => build_label_proc("Users")
      projects_menu = menu.add :label => build_label_proc("Projects")

      menu.items.should == [blog_post_menu, user_menu, projects_menu]
    end
  end
end

