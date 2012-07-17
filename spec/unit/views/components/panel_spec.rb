require 'spec_helper'

describe ActiveAdmin::Views::Panel do

  let(:the_panel) do
    render_arbre_component do
      panel "My Title" do
        span("Hello World")
      end
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
    the_panel = render_arbre_component do
      panel("Title", :icon => :arrow_down)
    end
    the_panel.find_by_tag("h3").first.content.should include("span class=\"icon")
  end

  describe "#children?" do

    it "returns false if no children have been added to the panel" do
      the_panel = render_arbre_component do
        panel("A Panel")
      end
      the_panel.children?.should == false
    end

  end

end
