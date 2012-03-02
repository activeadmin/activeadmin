require 'spec_helper'

describe ActiveAdmin::Views::Popover do

  setup_arbre_context!

  let(:the_popover) do
    popover :id => "my_awesome_popover" do
      para "Hello World, this is popover content baby."
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
  
  #describe "when content is given as the first arg" do
  #  let(:the_popover) do
  #    popover "BLAH BLAH BLAH", :id => "my_awesome_popover"
  #  end
  #  
  #  it "should render the contents when given as the first arg" do
  #    the_popover.find_by_class("popover_contents").first.content.should include("BLAH BLAH BLAH")
  #  end
  #end
  
end
