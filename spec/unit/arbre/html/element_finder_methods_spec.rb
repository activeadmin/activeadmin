require 'spec_helper'

describe Arbre::HTML::Element, "Finder Methods" do

  setup_arbre_context!

  describe "finding elements by tag name" do

    it "should return 0 when no elements exist" do
      div.get_elements_by_tag_name("li").size.should == 0
    end

    it "should return a child element" do
      html = div do
        ul
        li
        ul
      end
      elements = html.get_elements_by_tag_name("li")
      elements.size.should == 1
      elements[0].should be_instance_of(Arbre::HTML::Li)
    end

    it "should return multple child elements" do
      html = div do
        ul
        li
        ul
        li
      end
      elements = html.get_elements_by_tag_name("li")
      elements.size.should == 2
      elements[0].should be_instance_of(Arbre::HTML::Li)
      elements[1].should be_instance_of(Arbre::HTML::Li)
    end

    it "should return children's child elements" do
      html = div do
        ul
        li do
          li
        end
      end
      elements = html.get_elements_by_tag_name("li")
      elements.size.should == 2
      elements[0].should be_instance_of(Arbre::HTML::Li)
      elements[1].should be_instance_of(Arbre::HTML::Li)
      elements[1].parent.should == elements[0]
    end
  end

  describe "finding an element by id"
  describe "finding an element by a class name"
end
