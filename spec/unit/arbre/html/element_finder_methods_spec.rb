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

  #TODO: describe "finding an element by id"
  
  describe "finding an element by a class name" do
    it "should return 0 when no elements exist" do
      div.get_elements_by_class_name("my_class").size.should == 0
    end
    it "should return a child element" do
      html = div do
        div :class => "some_class"
        div :class => "my_class"
      end
      elements = html.get_elements_by_class_name("my_class")
      elements.size.should == 1
      elements[0].should be_instance_of(Arbre::HTML::Div)
    end

    it "should return multple child elements" do
      html = div do
        div :class => "some_class"
        div :class => "my_class"
        div :class => "my_class"
      end
      elements = html.get_elements_by_class_name("my_class")
      elements.size.should == 2
      elements[0].should be_instance_of(Arbre::HTML::Div)
      elements[1].should be_instance_of(Arbre::HTML::Div)
    end
    
    it "should return elements that match one of several classes" do
      html = div do
        div :class => "some_class this_class"
        div :class => "some_class"
        div :class => "other_class"
        
      end
      elements = html.get_elements_by_class_name("this_class")
      elements.size.should == 1
      elements[0].should be_instance_of(Arbre::HTML::Div)
    end
    
    #TODO: find children's children by class name
    
    #it "should return elements that are nested" do
    #  html = div do
    #    div :class => "my_class"
    #    div :class => "some_class" do
    #      ul :class => "other_class" do
    #        li :class => "special_awesome_class"
    #      end
    #    end
    #  end
    #  
    #  elements = html.get_elements_by_class_name("special_awesome_class")
    #
    #  elements.size.should == 1
    #  elements[0].should be_instance_of(Arbre::HTML::Li)
    #end
  end
end
