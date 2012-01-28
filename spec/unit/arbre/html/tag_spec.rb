require 'spec_helper'

describe Arbre::HTML::Tag do

  setup_arbre_context!

  let(:tag){ Arbre::HTML::Tag.new }

  describe "building a new tag" do
    before { tag.build "Hello World", :id => "my_id" }

    it "should set the contents to a string" do
      tag.content.should == "Hello World"
    end

    it "should set the hash of options to the attributes" do
      tag.attributes.should == { :id => "my_id" }
    end
  end

  describe "creating a tag 'for' an object" do
    let(:model_name){ mock(:singular => "resource_class", :param_key => 'resource_class')}
    let(:resource_class){ mock(:model_name => model_name) }
    let(:resource){ mock(:class => resource_class, :to_key => ['5'])}

    before do
      tag.build :for => resource
    end
    it "should set the id to the type and id" do
      tag.id.should == "resource_class_5"
    end
    it "should add a class name" do
      tag.class_list.should include("resource_class")
    end
  end

  describe "css class names" do
    it "should add a class" do
      tag.add_class "hello_world"
      tag.class_names.should == "hello_world"
    end

    it "should remove_class" do
      tag.add_class "hello_world"
      tag.class_names.should == "hello_world"
      tag.remove_class "hello_world"
      tag.class_names.should == ""
    end

    it "should not add a class if it already exists" do
      tag.add_class "hello_world"
      tag.add_class "hello_world"
      tag.class_names.should == "hello_world"
    end

    it "should seperate classes with space" do
      tag.add_class "hello world"
      tag.class_list.size.should == 2
    end
  end


end
