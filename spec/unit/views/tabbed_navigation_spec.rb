require 'spec_helper'

include ActiveAdmin
describe ActiveAdmin::Views::TabbedNavigation do

  let(:menu){ ActiveAdmin::Menu.new }

  let(:assigns){ { :active_admin_menu => menu } }
  let(:helpers){ mock_action_view }

  let(:tabbed_navigation) do 
    arbre(assigns, helpers) {
      insert_tag(ActiveAdmin::Views::TabbedNavigation, active_admin_menu)
    }.children.first
  end

  let(:html) { tabbed_navigation.to_s }

  before do
    helpers.stub!(:admin_logged_in?).and_return(false)
  end

  describe "rendering a menu" do

    before do
      menu.add MenuItem.new(:label => "Blog Posts",		:url => :admin_posts_path)
      menu.add MenuItem.new(:label => "Reports",		:url => "/admin/reports")
      menu.add MenuItem.new(:label => "Administration", :url => "/admin/administration")
      menu.add MenuItem.new(:label => "Management",		:url => "#")

      reports = menu["Reports"]
      reports.add MenuItem.new(:label => "A Sub Reports", :url => "/admin/a-sub-reports")
      reports.add MenuItem.new(:label => "B Sub Reports", :url => "/admin/b-sub-reports")

      administration = menu["Administration"]
      administration.add MenuItem.new(:label => "User administration", 
									  :url => '/admin/user-administration', 
									  :priority => 10, 
									  :if => proc { false })

      management = menu["Management"]
      management.add MenuItem.new(:label => "Order management", 
								  :url => '/admin/order-management', 
								  :priority => 10, 
								  :if => proc { false })
      management.add MenuItem.new(:label => "Bill management", 
								  :url => '/admin/bill-management', 
								  :priority => 10, 
								  :if => :admin_logged_in?)
    end

    it "should generate a ul" do
      html.should have_tag("ul")
    end

    it "should generate an li for each item" do
      html.should have_tag("li", :parent => { :tag => "ul" })
    end

    it "should generate a link for each item" do
      html.should have_tag("a", "Blog Posts", :attributes => { :href => '/admin/posts' })
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
        assigns[:current_tab] = menu["Blog Posts"]
        html.should have_tag("li", :attributes => { :class => "current" })
      end

      it "should add the 'current' and 'has_nested' classes to the li and 'current' to the sub li" do
        assigns[:current_tab] = menu["Reports"]["A Sub Reports"]
        html.should have_tag("li", :attributes => { :id => "reports", :class => /current/ })
        html.should have_tag("li", :attributes => { :id => "reports", :class => /has_nested/ })
        html.should have_tag("li", :attributes => { :id => "a_sub_reports", :class => "current" })
      end

    end

  end

  describe "returning the menu items to display" do

    it "should be reture one item with no if block" do
      menu.add MenuItem.new(:label => "Hello World", :url => "/")
      tabbed_navigation.menu_items.should == menu.items
    end

    it "should not include a menu items with an if block that returns false" do
      menu.add MenuItem.new(:label => "Don't Show", :url => "/", :priority => 10, :if => proc{ false })
      tabbed_navigation.menu_items.should == []
    end

    it "should not include menu items with an if block that calls a method that returns false" do
      menu.add MenuItem.new(:label => "Don't Show", :url => "/", :priority => 10, :if => :admin_logged_in?)
      tabbed_navigation.menu_items.should == []
    end

    it "should not display any items that have no children to display" do
      item = MenuItem.new(:label => "Parent", :url => "#") do |p|
        p.add MenuItem.new(:label => "Child", :url => "/", :priority => 10, :if => proc{ false })
      end
	  menu.add item
      tabbed_navigation.menu_items.should == []
    end

    it "should display a parent that has a child to display" do
      item = MenuItem.new(:label => "Parent", :url => "#") do |p|
        p.add MenuItem.new(:label => "Hidden Child", :url => "/", :priority => 10, :if => proc{ false })
        p.add MenuItem.new(:label => "Child", :url => "/")
      end
	  menu.add item
      tabbed_navigation.should have(1).menu_items
    end

  end

end
