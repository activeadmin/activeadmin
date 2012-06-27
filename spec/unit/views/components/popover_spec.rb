require 'spec_helper'

describe ActiveAdmin::Views::Popover do

  let(:the_popover) do
    render_arbre_component do
      popover :id => "my_awesome_popover" do
        para "Hello World, this is popover content baby."
      end
    end
  end

  it "should have the class of 'sidebar_section'" do
    the_popover.class_list.should include("popover")
  end

  it "should have an inner content element class of 'popover_contents'" do
    the_popover.find_by_tag("div").first.class_list.should include("popover_contents")
  end

  it "should have the popover content in the inner content element" do
    the_popover.find_by_class("popover_contents").first.content.should include("Hello World, this is popover content baby.")
  end

  it "should have an id" do
    the_popover.id.should == "my_awesome_popover"
  end

  it "should be hidden" do
    the_popover.attributes.should include(:style => "display: none");
  end

end
