require 'spec_helper'

describe ActiveAdmin::Views::TabsRenderer do

  let(:renderer){ ActiveAdmin::Views::TabsRenderer.new(mock_action_view) }
  let(:menu){ ActiveAdmin::Menu.new }
  let(:html){ renderer.to_html(menu) }

  # Generate a menu to use
  before do
    menu.add "Blog Posts", "/admin/blog-posts"
    menu.add "Reports", "/admin/reports"
    reports = menu["Reports"]
    reports.add "A Sub Reports", "/admin/a-sub-reports"
    reports.add "B Sub Reports", "/admin/b-sub-reports"
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

  it "should generate a " do
    html.should have_tag("a", "Blog Posts", :attributes => { :href => '/admin/blog-posts' })
  end

  it "should generate a nested list for children" do
    html.should have_tag("ul", :parent => { :tag => "li" })
  end

  it "should generate a nested list with li for each child" do
    html.should have_tag("li", :parent => { :tag => "ul" }, :attributes => {:id => "a_sub_reports"})
    html.should have_tag("li", :parent => { :tag => "ul" }, :attributes => {:id => "b_sub_reports"})
  end

  describe "marking current item" do
    it "should add the 'current' class to the li" do
      renderer.instance_variable_set :@current_tab, "Blog Posts"
      html.should have_tag("li", :attributes => { :class => "current" })
    end
    
    it "should add the 'current' and 'has_nested' classes to the li and 'current' to the sub li" do
      renderer.instance_variable_set :@current_tab, "Reports/A Sub Reports"
      html.should have_tag("li", :attributes => { :id => "reports", :class => "current has_nested" })
      html.should have_tag("li", :attributes => { :id => "a_sub_reports", :class => "current" })      
    end
  end

end
