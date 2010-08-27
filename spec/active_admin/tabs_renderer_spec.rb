require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::TabsRenderer do

  let(:renderer){ ActiveAdmin::TabsRenderer.new(mock_action_view) }
  let(:menu){ ActiveAdmin::Menu.new }
  let(:html){ renderer.to_html(menu) }

  # Generate a menu to use
  before do
    menu.add "Blog Posts", "/admin/blog-posts"
    menu.add "Reports", "/admin/reports"
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

  describe "marking current item" do
    it "should add the 'current' class to the li" do
      renderer.instance_variable_set :@current_tab, "Blog Posts"
      html.should have_tag("li", :attributes => { :class => "current" })
    end
  end

end
