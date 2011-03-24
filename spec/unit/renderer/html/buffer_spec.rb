require 'spec_helper'

describe ActiveAdmin::Renderer::HTML::Buffer do
  include ActiveAdmin::Renderer::HTML
  let(:buffer) { ActiveAdmin::Renderer::HTML::Buffer.new }

  describe "inserting a tag into the buffer" do
    let(:tag_class) { ActiveAdmin::Renderer::HTML::Span }
    let(:tag) { tag_class.new }

    it "should set the document on the tag" do
      buffer.insert tag
      tag.document.should == buffer
    end

    it "should return the tag" do
      buffer.insert(tag).should == tag
    end

    it "should call build with the tag arguments" do
      tag.should_receive(:build).with('content', :id => 'my_span')
      buffer.insert tag, 'content', :id => 'my_span'
    end

    context "with a child block" do
      let(:child_tag) { tag_class.new }
      before do
        buffer.insert tag do
          buffer.insert child_tag
        end
      end

      it "should set the children on the tag" do
        tag.children.size.should == 1
        tag.children.first.should == child_tag
      end

      it "should not add the children to main buffer" do
        buffer.children.size.should == 1
        buffer.children.first.should == tag
      end
    end

    context "with a child block that returns a string" do
      before do
        buffer.insert tag do
          "Hello World"
        end
      end

      it "should add the string as a text node" do
        tag.children.size.should == 1
        tag.children.first.should be_instance_of(ActiveAdmin::Renderer::HTML::TextNode)
      end
    end
  end

  describe "rendering a buffer" do
    it "should call to_html on the collection" do
      buffer.children.should_receive(:to_html).and_return("content")
      buffer.to_html.should == "content"
    end
  end

end
