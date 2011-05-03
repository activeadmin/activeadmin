require 'spec_helper'

describe Arbre::HTML do
  include Arbre::HTML

  let(:assigns){ {} }

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
    list_1.should be_instance_of(Arbre::HTML::Ul)
    list_2.should be_instance_of(Arbre::HTML::Li)
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

  it "should add children and nested" do
    content = div do
      ul
      li do
        li
      end
    end
    content.to_html.should == "<div><ul></ul><li><li></li></li></div>"
  end

  it "should pass the element in to the block if asked for" do
    content = div do |d|
      d.ul do
        li
      end
    end
    content.to_html.should == "<div><ul><li></li></ul></div>"
  end

  it "should move content tags between parents" do
    content = div do
      span(ul(li))
    end
    content.to_html.should == "<div><span><ul><li></li></ul></span></div>"
  end

  it "should add content to the parent if the element is passed into block" do
    content = div do |d|
      d.id = "my-tag"
      ul do
        li
      end
    end
    content.to_html.should == "<div id=\"my-tag\"><ul><li></li></ul></div>"
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
      end.children.first.should be_instance_of(Arbre::HTML::TextNode)
    end
  end

  describe "html safe" do
    it "should escape the contents" do
      span("<br />").to_html.should == "<span>&lt;br /&gt;</span>"
    end

    it "should return html safe strings" do
      span("<br />").to_html.should be_html_safe
    end

    it "should not escape html passed in" do
      span(span("<br />")).to_html.should == "<span><span>&lt;br /&gt;</span></span>"
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
