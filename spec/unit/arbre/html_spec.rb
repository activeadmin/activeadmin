require 'spec_helper'

describe Arbre do

  setup_arbre_context!

  it "should render a single element" do
    content = span("Hello World")
    content.to_s.should == <<-HTML
<span>Hello World</span>
HTML
  end

  it "should render a child element" do
    content = span do
      span "Hello World"
    end
    content.to_s.should == <<-HTML
<span>
  <span>Hello World</span>
</span>
HTML
  end

  it "should render an unordered list" do
    content = ul do
      li "First"
      li "Second"
      li "Third"
    end
    content.to_s.should == <<-HTML
<ul>
  <li>First</li>
  <li>Second</li>
  <li>Third</li>
</ul>
HTML
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
    content.to_s.should == <<-EOS
<ul>
  <li>First</li>
  <li>Second</li>
</ul>
EOS
  end

  it "should add children and nested" do
    content = div do
      ul
      li do
        li
      end
    end
    content.to_s.should == <<-HTML
<div>
  <ul></ul>
  <li>
    <li></li>
  </li>
</div>
HTML
  end

  it "should pass the element in to the block if asked for" do
    content = div do |d|
      d.ul do
        li
      end
    end
    content.to_s.should == <<-HTML
<div>
  <ul>
    <li></li>
  </ul>
</div>
HTML
  end

  it "should move content tags between parents" do
    content = div do
      span(ul(li))
    end
    content.to_s.should == <<-HTML
<div>
  <span>
    <ul>
      <li></li>
    </ul>
  </span>
</div>
HTML
  end

  it "should add content to the parent if the element is passed into block" do
    content = div do |d|
      d.id = "my-tag"
      ul do
        li
      end
    end
    content.to_s.should == <<-HTML
<div id="my-tag">
  <ul>
    <li></li>
  </ul>
</div>
HTML
  end

  it "should have the parent set on it" do
    item = nil
    list = ul do
      li "Hello"
      item = li "World"
    end
    item.parent.should == list
  end


  ["Hello World", 1, 1.5].each do |value|
    it "should append the return value of '#{value}' when no other children added to the DOM" do
      li do
        value
      end.to_s.should == "<li>#{value}</li>\n"
    end
  end

  ["Hello World", 1, 1.5].each do |value|
    it "should not append the return value of '#{value}' when children have been added to the DOM" do
      li do
        text_node("Already Added")
        value
      end.to_s.should == "<li>Already Added</li>\n"
    end
  end

  describe "text nodes" do
    it "should turn strings into text nodes" do
      li do
        "Hello World"
      end.children.first.should be_instance_of(Arbre::HTML::TextNode)
    end
  end

  describe "self-closing nodes" do
    it "should not self-close script tags" do
      tag = script :type => 'text/javascript'
      tag.to_s.should == <<-HTML
<script type="text/javascript"></script>
HTML
    end
    it "should self-close meta tags" do
      tag = meta :content => "text/html; charset=utf-8"
      tag.to_s.should == <<-HTML
<meta content="text/html; charset=utf-8\"/>
HTML
    end
    it "should self-close link tags" do
      tag = link :rel => "stylesheet"
      tag.to_s.should == <<-HTML
<link rel="stylesheet"/>
HTML
    end
  end

  describe "html safe" do
    it "should escape the contents" do
      span("<br />").to_s.should == <<-HTML
<span>&lt;br /&gt;</span>
HTML
    end

    it "should return html safe strings" do
      span("<br />").to_s.should be_html_safe
    end

    it "should not escape html passed in" do
      span(span("<br />")).to_s.should == <<-HTML
<span>
  <span>&lt;br /&gt;</span>
</span>
HTML
    end

    it "should escape string contents when passed in block" do
      span {
        span {
          "<br />"
        }
      }.to_s.should == <<-HTML
<span>
  <span>&lt;br /&gt;</span>
</span>
HTML
    end

    it "should escape the contents of attributes" do
      span(:class => "<br />").to_s.should == <<-HTML
<span class="&lt;br /&gt;"></span>
HTML
    end
  end
  
  it "should not render blank nodes" do
    tbody = tbody do
      []
    end
    tbody.to_s.should == <<-HTML
<tbody></tbody>
HTML
  end

end
