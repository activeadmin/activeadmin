require 'spec_helper'

describe ActiveAdmin::Renderer, "HTML DSL" do

  include ActiveAdmin::Renderer::HTML

  it "should render a single element" do
    content = span("Hello World")
    content.to_html.should == "<span>Hello World</span>"
  end

  it "should render a child element" do
    content = span do
      span "Hello World"
    end
    content.to_html.should == "<span><span>Hello World</span></span>"
  end

  it "should render an unordered list" do
    content = ul do
      li "First"
      li "Second"
      li "Third"
    end
    content.to_html.should == "<ul><li>First</li><li>Second</li><li>Third</li></ul>"
  end

  it "should return the correct object" do
    list_1 = ul
    list_2 = li
    list_1.should be_instance_of(ActiveAdmin::Renderer::HTML::Ul)
    list_2.should be_instance_of(ActiveAdmin::Renderer::HTML::Li)
  end

  it "should allow local variables inside the tags" do
    first = "First"
    second = "Second"
    content = ul do
      li first
      li second
    end
    content.to_html.should == "<ul><li>First</li><li>Second</li></ul>"
  end

  it "should have the parent set on it" do
    item = nil
    list = ul do
      li "Hello"
      item = li "World"
    end
    item.parent.should == list
  end

  it "should set a string content return value with no children" do
    li do
      "Hello World"
    end.to_html.should == "<li>Hello World</li>"
  end

  describe "text nodes" do
    it "should turn strings into text nodes" do
      li do
        "Hello World"
      end.children.first.should be_instance_of(ActiveAdmin::Renderer::HTML::TextNode)
    end
  end

  describe "html safe" do
    it "should escape the contents" do
      span("<br />").to_html.should == "<span>&lt;br /&gt;</span>"
    end

    it "should escape string contents when passed in block" do
      span {
        span {
          "<br />"
        }
      }.to_html.should == "<span><span>&lt;br /&gt;</span></span>"
    end

    it "should escape the contents of attributes"
  end

end
