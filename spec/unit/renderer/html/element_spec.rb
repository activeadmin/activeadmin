require 'spec_helper'

include ActiveAdmin::Renderer::HTML

describe ActiveAdmin::Renderer::HTML::Element do

  let(:element){ Element.new }

  context "when initialized" do
    it "should have no children" do
      element.children.should be_empty
    end
    it "should have no parent" do
      element.parent.should be_nil
    end
    it "should have no document" do
      element.document.should be_nil
    end
    it "should respond to the HTML builder methods" do
      element.should respond_to(:span)
    end
  end

  describe "adding a child" do
    let(:child){ Element.new }
    before do
      element.add_child child
    end

    it "should add the child to the parent" do
      element.children.first.should == child
    end

    it "should set the parent of the child" do
      child.parent.should == element
    end

    context "when the child is nil" do
      let(:child){ nil }
      it "should not add the child" do
        element.children.should be_empty
      end
    end

    context "when the child is a string" do
      let(:child){ "Hello World" }
      it "should add as a TextNode" do
        element.children.first.should be_instance_of(TextNode)
        element.children.first.to_html.should == "Hello World"
      end
    end
  end

  describe "setting string content" do
    before do
      element.add_child "Hello World"
      element.content = "Goodbye"
    end
    it "should clear the existing children" do
      element.children.size.should == 1
    end

    it "should add the string as a child" do
      element.children.first.to_html.should == "Goodbye"
    end

    it "should html escape the string" do
      string = "Goodbye"
      ERB::Util.should_receive(:html_escape).with(string)
      element.content = string
    end
  end

  describe "setting the parent" do
    let(:parent) do
      parent = Element.new
      parent.document = Buffer.new
      parent
    end
    before { element.parent = parent }

    it "should set the parent" do
      element.parent.should == parent
    end
    it "should set the document to the parent's document" do
      element.document.should == parent.document
    end
  end

  describe "rendering to html" do
    it "should render the children collection" do
      element.children.should_receive(:to_html).and_return("content")
      element.to_html.should == "content"
    end
  end

end
