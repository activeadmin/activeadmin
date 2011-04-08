require 'spec_helper'
include ActiveAdmin::HTML

describe ActiveAdmin::HTML::Tag do
  let(:tag){ Tag.new }

  describe "building a new tag" do
    before { tag.build "Hello World", :id => "my_id" }

    it "should set the contents to a string" do
      tag.content.should == "Hello World"
    end

    it "should set the hash of options to the attributes" do
      tag.attributes.should == { :id => "my_id" }
    end
  end

  describe "attributes" do
    before { tag.build :id => "my_id" }

    it "should have an attributes hash" do
      tag.attributes.should == {:id => "my_id"}
    end

    it "should render the attributes to html" do
      tag.to_html.should == '<tag id="my_id"></tag>'
    end

    it "should get an attribute value" do
      tag.attr(:id).should == "my_id"
    end

    describe "#has_attribute?" do
      context "when the attribute exists" do
        it "should return true" do
          tag.has_attribute?(:id).should == true
        end
      end

      context "when the attribute does not exist" do
        it "should return false" do
          tag.has_attribute?(:class).should == false
        end
      end
    end

    it "should remove an attribute" do
      tag.attributes.should == {:id => "my_id"}
      tag.remove_attribute(:id).should == "my_id"
      tag.attributes.should == {}
    end
  end

  describe "creating a tag 'for' an object" do
    let(:model_name){ mock(:singular => "resource_class")}
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
