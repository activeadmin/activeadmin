require 'spec_helper'

describe ActiveAdmin::Views::TabbedNavigation do

  setup_arbre_context!
  include ActiveAdmin::ViewHelpers

  let(:menu){ ActiveAdmin::Menu.new }
  let(:tabbed_navigation){ insert_tag(ActiveAdmin::Views::TabbedNavigation, menu) }
  let(:html) { tabbed_navigation.to_s }

  before do
    helpers.stub!(:admin_logged_in?).and_return(false)
  end

  describe "rendering a menu" do

    before do
      menu.add "Blog Posts", "/admin/blog-posts"
      menu.add "Reports", "/admin/reports"
      reports = menu["Reports"]
      reports.add "A Sub Reports", "/admin/a-sub-reports"
      reports.add "B Sub Reports", "/admin/b-sub-reports"
      menu.add "Administration", "/admin/administration"
      administration = menu["Administration"]
      administration.add "User administration", '/admin/user-administration', 10, :if => proc { false }
      menu.add "Management", "#"
      management = menu["Management"]
      management.add "Order management", '/admin/order-management', 10, :if => proc { false }
      management.add "Bill management", '/admin/bill-management', 10, :if => :admin_logged_in?
    end

    it "should generate a ul" do
      html.should have_tag("ul")
    end

    it "should generate an li for each item" do
      html.should have_tag("li", :parent => { :tag => "ul" })
    end

    it "should generate a link for each item" do
      html.should have_tag("a", "Blog Posts", :attributes => { :href => '/admin/blog-posts' })
    end

    it "should generate a nested list for children" do
      html.should have_tag("ul", :parent => { :tag => "li" })
    end

    it "should generate a nested list with li for each child" do
      html.should have_tag("li", :parent => { :tag => "ul" }, :attributes => {:id => "a_sub_reports"})
      html.should have_tag("li", :parent => { :tag => "ul" }, :attributes => {:id => "b_sub_reports"})
    end

    it "should not generate a link for user administration" do
      html.should_not have_tag("a", "User administration", :attributes => { :href => '/admin/user-administration' })
    end

    it "should generate the administration parent menu" do
      html.should have_tag("a", "Administration", :attributes => { :href => '/admin/administration' })
    end

    it "should not generate a link for order management" do
      html.should_not have_tag("a", "Order management", :attributes => { :href => '/admin/order-management' })
    end

    it "should not generate a link for bill management" do
      html.should_not have_tag("a", "Bill management", :attributes => { :href => '/admin/bill-management' })
    end

    it "should not generate the management parent menu" do
      html.should_not have_tag("a", "Management", :attributes => { :href => '#' })
    end

    describe "marking current item" do

      it "should add the 'current' class to the li" do
        assigns[:current_tab] = "Blog Posts"
        html.should have_tag("li", :attributes => { :class => "current" })
      end

      it "should add the 'current' and 'has_nested' classes to the li and 'current' to the sub li" do
        assigns[:current_tab] = "Reports/A Sub Reports"
        html.should have_tag("li", :attributes => { :id => "reports", :class => "current has_nested" })
        html.should have_tag("li", :attributes => { :id => "a_sub_reports", :class => "current" })
      end

    end

  end

  describe "returning the menu items to display" do

    it "should be reture one item with no if block" do
      menu.add "Hello World", "/"
      tabbed_navigation.menu_items.should == menu.items
    end

    it "should not include a menu items with an if block that returns false" do
      menu.add "Don't Show", "/", 10, :if => proc{ false }
      tabbed_navigation.menu_items.should == []
    end

    it "should not include menu items with an if block that calls a method that returns false" do
      menu.add "Don't Show", "/", 10, :if => :admin_logged_in?
      tabbed_navigation.menu_items.should == []
    end

    it "should not display any items that have no children to display" do
      menu.add "Parent", "#" do |p|
        p.add "Child", "/", 10, :if => proc{ false }
      end
      tabbed_navigation.menu_items.should == []
    end

    it "should display a parent that has a child to display" do
      menu.add "Parent", "#" do |p|
        p.add "Hidden Child", "/", 10, :if => proc{ false }
        p.add "Child", "/"
      end
      tabbed_navigation.should have(1).menu_items
    end

  end

end
