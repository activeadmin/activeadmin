require 'spec_helper'

describe ActiveAdmin::Views::Popover do

  let(:the_popover) do
    render_arbre_component do
      popover id: "my_awesome_popover" do
        para "Hello World, this is popover content baby."
      end
    end
  end

  it "should have the class of 'sidebar_section'" do
    expect(the_popover.class_list).to include("popover")
  end

  it "should have an inner content element class of 'popover_contents'" do
    expect(the_popover.find_by_tag("div").first.class_list).to include("popover_contents")
  end

  it "should have the popover content in the inner content element" do
    expect(the_popover.find_by_class("popover_contents").first.content).to include("Hello World, this is popover content baby.")
  end

  it "should have an id" do
    expect(the_popover.id).to eq "my_awesome_popover"
  end

  it "should be hidden" do
    expect(the_popover.attributes).to include(style: "display: none");
  end

end
