require 'spec_helper'

describe ActiveAdmin::Views::Panel do

  setup_arbre_context!

  let(:the_panel) do
    panel "My Title" do
      span("Hello World")
    end
  end

  it "should have a title h3" do
    the_panel.find_by_tag("h3").first.content.should == "My Title"
  end

  it "should have a contents div" do
    the_panel.find_by_tag("div").first.class_list.should include("panel_contents")
  end

  it "should add children to the contents div" do
    the_panel.find_by_tag("span").first.parent.should == the_panel.find_by_tag("div").first
  end

  it "should set the icon" do
    panel("Title", :icon => :arrow_down).find_by_tag("h3").first.content.should include("span class=\"icon")
  end

end
