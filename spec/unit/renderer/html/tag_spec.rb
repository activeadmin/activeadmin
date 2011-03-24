require 'spec_helper'
include ActiveAdmin::Renderer::HTML

describe ActiveAdmin::Renderer::HTML::Tag do
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
end
